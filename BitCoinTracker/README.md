# README

## Test Assignment  

+ Сделать приложение для отображения текущего курса биткоина.
+ Пользователь может выбирать валюту и обменник.
+ Если текущий курс растет, отображаем текст зеленым. Если падает, то красным.

+ Изменение текста сделать с анимацией.
+ Желательно не делать всё в одном контроллере, а применить архитектуру во выбору.

### Для работы приложения нужно:

1)  Подсоединиться по вебсокету к `"ws://bitcoinstat.org:9000"`
2)  Чтобы сервер начал слать текущий курс, шлём:
`{"subscribe":"trade.btc_валюта_обменник"}`
где возможные значения для валюты: `usd`, `eur`
возможные значения для обменника: `kraken`, `bitstamp`,
`coinbasepro`, `gemini`
пример: `{"subscribe":"trade.btc_usd_kraken"}`
курс будет приходить в виде:
`{"time":1610552651,"price":"34650.00000","quantity":0.015,"type":"sell"}`
в данном приложении нас интересует только `price`
3) чтобы перестать получать курс, шлём:
`{"unsubscribe":"trade.btc_валюта_обменник"}`

## Dependencies:
#### for simple use,please, add link on github to Swift Packages  
 - [StarScream WebSocket Library](https://github.com/daltoniam/Starscream "add link on github to Swift Packages ")

