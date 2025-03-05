#!/bin/bash
set +x
# Функция обработки файлов
process_file() {
    local preprod_file="$1"
    local relative_path="${preprod_file#$PREPROD_DIR/}"  # Относительный путь
    local perf_file="$PERF_DIR/$relative_path"
    perf_file="${perf_file/preprod/perf}"  # Заменяем в пути preprod → perf

    echo "============================="
    echo "Проверяем файл: $preprod_file"
    echo "Ожидаемый perf-файл: $perf_file"

    if [[ ! -f "$perf_file" ]]; then
        echo "Файл $perf_file не найден, пропускаем."
        return
    fi

    # Сохраняем ресурсы из perf
    # memory
    limits_memory=$(grep -E '^\s*memory:' "$perf_file" | awk '{print $2}' | head -n 1)
    requests_memory=$(grep -E '^\s*memory:' "$perf_file" | awk 'NR==2 {print $2}' | head -n 1)
    # cpu
    limits_cpu=$(grep -E '^\s*cpu:' "$perf_file" | awk '{print $2}' | head -n 1)
    requests_cpu=$(grep -E '^\s*cpu:' "$perf_file" | awk 'NR==2 {print $2}' | head -n 1)

    # loadbalancerIP (если есть)
    loadbalancerIP=$(grep -E '^\s*loadbalancerIP:' "$perf_file" | awk '{print $2}' | head -n 1)

    # minimum-idle (если есть)
    minimum_idle=$(grep -E '^\s*minimum-idle:' "$perf_file" | awk '{print $2}' | head -n 1)

    # maximum-pool-size (если есть)
    maximum_pool_size=$(grep -E '^\s*maximum-pool-size:' "$perf_file" | awk '{print $2}' | head -n 1)
    
    # uri (если есть)
    uri=$(grep -E '^\s*uri:' "$perf_file" | awk '{print $2}' | head -n 1)

    echo "Сохраненные ресурсы:"
    echo "limits.memory = $limits_memory"
    echo "requests.memory = $requests_memory"
    echo "limits.cpu = $limits_cpu"
    echo "requests.cpu = $requests_cpu"
    echo "loadbalancerIP = $loadbalancerIP"
    echo "minimum-idle = $minimum_idle"
    echo "maximum-pool-size = $maximum_pool_size"
    echo "uri = $uri"

    echo "Копируем $preprod_file → $perf_file"
    cp "$preprod_file" "$perf_file"

    echo "Заменяем 'preprod' → 'perf' в $perf_file"
    sed -i '' 's/preprod/perf/g' "$perf_file" 

    # Восстанавливаем ресурсы, если они есть в файле
    echo "Восстанавливаем ресурсы..."

    if [[ -n "$limits_memory" ]]; then
        grep -n '^[ \t]*memory' "$perf_file" | head -n 1 | cut -d: -f1 | xargs -I {} sed -i '' '{}s/^\([ \t]*memory:\).*/\1 '"$limits_memory"'/' "$perf_file"
    fi

    if [[ -n "$limits_cpu" ]]; then
        grep -n '^[ \t]*cpu' "$perf_file" | head -n 1 | cut -d: -f1 | xargs -I {} sed -i '' '{}s/^\([ \t]*cpu:\).*/\1 '"$limits_cpu"'/' "$perf_file"
    fi

    if [[ -n "$requests_cpu" ]]; then
        grep -n '^[ \t]*cpu' "$perf_file" | head -n 2 | tail -n 1 |cut -d: -f1 | xargs -I {} sed -i '' '{}s/^\([ \t]*cpu:\).*/\1 '"$requests_cpu"'/' "$perf_file"
    fi

    if [[ -n "$requests_memory" ]]; then
        grep -n '^[ \t]*memory' "$perf_file" | head -n 2 | tail -n 1 | cut -d: -f1 | xargs -I {} sed -i '' '{}s/^\([ \t]*memory:\).*/\1 '"$requests_memory"'/' "$perf_file"
    fi

    if [[ -n "$loadbalancerIP" ]]; then
        grep -n '^[ \t]*loadbalancerIP' "$perf_file" | head -n 1 | cut -d: -f1 | xargs -I {} sed -i '' '{}s/^\([ \t]*loadbalancerIP:\).*/\1 '"$loadbalancerIP"'/' "$perf_file"
    fi

    if [[ -n "$minimum_idle" ]]; then
        grep -n '^[ \t]*minimum-idle' "$perf_file" | head -n 1 | cut -d: -f1 | xargs -I {} sed -i '' '{}s/^\([ \t]*minimum-idle:\).*/\1 '"$minimum_idle"'/' "$perf_file"
    fi

    if [[ -n "$maximum_pool_size" ]]; then
        grep -n '^[ \t]*maximum-pool-size' "$perf_file" | head -n 1 | cut -d: -f1 | xargs -I {} sed -i '' '{}s/^\([ \t]*maximum-pool-size:\).*/\1 '"$maximum_pool_size"'/' "$perf_file"
    fi

    if [[ -n "$uri" ]]; then
        grep -n '^[ \t]*uri' "$perf_file" | head -n 1 | cut -d: -f1 | xargs -I {} sed -i '' '{}s/^\([ \t]*uri:\).*/\1 '"$uri"'/' "$perf_file"
    fi

    echo "Файл обновлен: $perf_file"
    echo "============================="
}

# Главная функция
main() {
    # Получаем аргументы
    PREPROD_DIR="$1"
    PERF_DIR="$2"

    if [[ -z "$PREPROD_DIR" || -z "$PERF_DIR" ]]; then
        echo "Ошибка: укажите две папки (с preprod и perf)"
        echo "Пример: $0 ./argo_preprod ./argo_perf"
        exit 1
    fi

    echo "Начинаем обработку файлов..."
    echo "Папка с preprod: $PREPROD_DIR"
    echo "Папка с perf: $PERF_DIR"
    echo ""

    # Логируем пути для отладки
    echo "Сканируем папку $PREPROD_DIR на наличие *preprod.yaml файлов..."

    # Используем find для поиска файлов и цикл for для обработки
    find "$PREPROD_DIR" -type f -name "*preprod.yaml" -print0 | while IFS= read -r -d '' preprod_file; do
        echo "Найден файл: $preprod_file"
        process_file "$preprod_file"
    done

    echo ""
    echo "Обработка завершена!"
}

# Вызываем главную функцию с передачей всех аргументов
main "$@"
