﻿

Процедура ДанныеДляОтображения_Добавить(Данные, Источник) Экспорт
	
	НоваяСтрока = ДанныеДляОтображения.Добавить();
	НоваяСтрока.Источник = Источник;
	НоваяСтрока.Данные = Данные;
	
КонецПроцедуры

ДанныеДляОтображения.Колонки.Добавить("Источник", Новый ОписаниеТипов("Строка"));
ДанныеДляОтображения.Колонки.Добавить("Данные"); // в этом поле может быть табличный документ, таблица значений или что-нибудь еще


