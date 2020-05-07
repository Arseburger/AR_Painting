ARPainting
==============

ARPainting - приложение, с помощью которого можно виртуально (используя AR) добавить на вертикальную плоскость (например, стену) любое изображение из галереи пользователя или случайно полученное с сайта Unsplash.

# Функции приложения:
<li> Добавление изображения на вертикальную плоскость ✅
<li> Возможность вставить картинку из галереи устройства ✅ 
<li> Загрузка случайной картинки с Unsplash ✅
<li> Сохранение сцены приложения с прикреплённым изображением в галерею ✅
<li> Возможность поделиться сценой ✅
  
# Дополнительные функции: 
<li> Возможность вставить картинку с камеры устройства ❓
<li> Добавление рамки вокруг изображения ❓

# Запуск приложения:
Так как Unsplash API имеет ограничение в 50 запросов в час, иногда может не срабатывать метод getRandomImage(). Рекомендую перед запуском получить свой accessKey на сайте [Unsplash](https://unsplash.com/developers) и указать его в файле NetworkConstants в поле accessKey. 

# Особенности:
В силу того, что замыкания оказались сильнее меня, после загрузки фото с Unsplash на экране выбора изображения лучше подождать несколько секунд, прежде чем нажимать на кнопку "Готово". При выборе изображения из галереи таких проблем нет (у меня не получилось настолько быстро нажать на кнопку), но в теории они могут появиться.

# Дизайн:
**[Ссылка](https://www.figma.com/file/OF5c3XlXM4HblWQAlhq8BE/ARPainting?node-id=19%3A22)** на использованные (если им повезло) элементы интерфейса.

# Использование:
При запуске приложение попросит доступ к камере и галерее. Чтобы приложение могло работать, нужно разрешить доступ. Далее надо найти хорошо различимую вертикальную поверхность (желательно, не монотонную). Когда такая поверхность будет обнаружена, на ней появится изображение, сообщающее об этом. Далее нужно навести синюю точку в центре экрана на эту плоскость и нажать на экран. После этого появится встроенное изображение. Чтобы очистить сцену, надо нажать на кнопку с крестиком. Для выбора фотографии для отображения необходимо нажать на кнопку галереи (левая). Далее необходимо выбрать изображение и нажать на кнопку "готово" (тут смотрим пункт "Особенности"). После этого повторяем действия, описанные ранее. Также есть возможность поделиться сценой приложения или сохранить ее в галерею. Для этого надо нажать на иконку камеры и на новом экране нажать на конверт в правом верхнем углу. Появится окно выбора опций. 
