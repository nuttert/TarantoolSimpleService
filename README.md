# TarantoolSimpleService
Запуск локально(также необходимо будет провести настройки в админке на ручке /admin):
```
cartridge build
cartridge start
```
# Тестинг через готовый сервер:
```
Host:95.163.182.67
Port: 8081

Пример:
curl -X GET 95.163.182.67:8081/kv/10
response:
{"info":"Object not found: 404"}
```

**POST,GET,PUT,DELETE** запросы:
```
curl -X POST localhost:8081/kv --data '{"key":"10","value":{"abc":1}}'
response:
{"info":"Successfully created"}

curl -X GET localhost:8081/kv/10
response:
{"key":"10","value":{"abc":1}}

curl -X PUT localhost:8081/kv/10 --data '{"value":{"abc":20}}'
response:
{"key":"10","value":{"abc":20}}

curl -X DELETE localhost:8081/kv/10
response:
{"info":"Deleted"}
```

Некоторые некорректные запросы:
```
curl -X POST localhost:8081/kv --data '{"key":"10","value":{"abc:1}}'
response:
{"info":"Body is not correct: 400"}

curl -X POST localhost:8081/kv --data '{"key":"10","value":{"abc":1}}'
response:
{"info":"Object already exist: 409"}

curl -X DELETE localhost:8081/kv/200
response:
{"info":"Object not found: 404"}
```

