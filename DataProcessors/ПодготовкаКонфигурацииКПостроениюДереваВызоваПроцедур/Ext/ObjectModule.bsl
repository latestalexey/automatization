﻿
#Область _ // Копирование файлов для обработки

Процедура СкопироватьФайлыОбъектовПоМассивуМасок(МассивМасок) Экспорт
	
	КаталогИсточник = ПолучитьПутьКФайлуВСтандартномФормате(КаталогИсходныхФайлов);
	КаталогПриемник = ПолучитьПутьКФайлуВСтандартномФормате(КаталогСборки);
	
	//УдалитьФайлы(КаталогПриемник);
	КопируемыеФайлы.Очистить();
	
	Для Каждого Маска Из МассивМасок Цикл
		НайденныеФайлы = НайтиФайлы(КаталогИсходныхФайлов+ПолучитьРазделительПути()+ Маска, "*.bsl", Истина);
		Для Каждого НайденныйФайл Из НайденныеФайлы Цикл
			Если ПустаяСтрока(НайденныйФайл.Расширение) Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = КопируемыеФайлы.Добавить();
			НоваяСтрока.ФайлИсточник = НайденныйФайл.ПолноеИмя;
			НоваяСтрока.ФайлПриемник = КаталогПриемник+Сред(НайденныйФайл.ПолноеИмя, СтрДлина(КаталогИсточник)+1);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Строка из КопируемыеФайлы Цикл
		СкопироватьФайлСРодительскимиКаталогами(Строка.ФайлИсточник, Строка.ФайлПриемник);
	КонецЦикла;
	
КонецПроцедуры

Процедура СкопироватьФайлСРодительскимиКаталогами(ИмяФайлаИсточника, ИмяФайлаПриемника)
	
	Файл = Новый Файл(ИмяФайлаПриемника);
	
	СоздатьКаталогСРодительскими(Файл.Путь);
	
	КопироватьФайл(ИмяФайлаИсточника, ИмяФайлаПриемника);
	
КонецПроцедуры

Процедура СоздатьКаталогСРодительскими(Путь)
	Каталог = Новый Файл(Путь);
	Если Каталог.Существует() Тогда
		Возврат;
	ИначеЕсли НайтиФайлы(Каталог.Путь).Количество() = 0 Тогда
		СоздатьКаталогСРодительскими(Каталог.Путь);
	КонецЕсли;
	
	СоздатьКаталог(Путь);
	
КонецПроцедуры


Функция ПолучитьПутьКФайлуВСтандартномФормате(ИсходныйПуть)
	НайденныеФайлы = НайтиФайлы(ИсходныйПуть);
	Если НайденныеФайлы.Количество() Тогда
		Возврат НайденныеФайлы[0].ПолноеИмя;
	КонецЕсли;
	
	Файл = Новый Файл(ИсходныйПуть);
	Возврат Файл.ПолноеИмя;
КонецФункции

Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Строка));
		Иначе
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

#КонецОбласти

#Область _ // Подстановка меток в модули
Процедура ПодставитьМеткиВФайлы(КаталогФайлов) Экспорт
	
	//НайденныеФайлы = НайтиФайлы(КаталогФайлов, "*.bsl", Истина);
	//Для Каждого Файл Из НайденныеФайлы Цикл
	Для каждого Строка из КопируемыеФайлы Цикл
		Файл = Новый Файл(Строка.ФайлПриемник);
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(Файл.ПолноеИмя);
		
		Префикс = СтрЗаменить(Файл.Путь, КаталогФайлов, "");
		Префикс = СтрЗаменить(Префикс, "\Ext\", ".");
		Префикс = СтрЗаменить(Префикс, "\", ".");
		Если Лев(Префикс,1) = "." Тогда
			Префикс = Сред(Префикс, 2);
		КонецЕсли;
		
		ДобавитьМеткиВТекстовыйДокумент(ТекстовыйДокумент, Префикс);
		
		ТекстовыйДокумент.Записать(Файл.ПолноеИмя);
	КонецЦикла;
	
КонецПроцедуры


Процедура ДобавитьМеткиВТекстовыйДокумент(ТекстовыйДокумент, Префикс) 
	Текст = ТекстовыйДокумент.ПолучитьТекст();
	Курсор = 0;
	Слово = Неопределено;
	
	Пока СчитатьСледующееСлово(Текст, Курсор, Слово) Цикл
		Если Лев(Слово, 2) = "//" Тогда
			ОбойтиКомментарий(Текст, Курсор);
		ИначеЕсли Лев(Слово, 1) = """" Тогда
			ОбойтиСтроковуюКонстанту(Текст, Курсор, Слово);
		ИначеЕсли нрег(Слово) = "функция" Тогда
			ДобавитьМеткуВНачалоМетода(Текст, Курсор, Префикс);
		ИначеЕсли нрег(Слово) = "процедура" Тогда
			ДобавитьМеткуВНачалоМетода(Текст, Курсор, Префикс);
		ИначеЕсли нрег(Слово) = "конецфункции" Тогда
			ДобавитьМеткуВКонецМетода(Текст, Курсор, Слово);
		ИначеЕсли нрег(Слово) = "конецпроцедуры" Тогда
			ДобавитьМеткуВКонецМетода(Текст, Курсор, Слово);
		ИначеЕсли нрег(Слово) = "возврат" Тогда
			ДобавитьМеткуВКонецМетода(Текст, Курсор, Слово);
		КонецЕсли;
	КонецЦикла;
	
	ТекстовыйДокумент.УстановитьТекст(Текст);
КонецПроцедуры
Процедура ОбойтиКомментарий(Текст, Курсор)
	
	Слово = Неопределено;
	Пока СчитатьСледующееСлово(Текст, Курсор, Слово) Цикл
		Если Слово = Символы.ПС Тогда
			Возврат;
		ИначеЕсли Слово = Символы.ВК Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
Процедура ОбойтиСтроковуюКонстанту(Текст, Курсор, Слово)
	
	Слово = Неопределено;
	ПредыдущееСлово = Неопределено;
	Пока СчитатьСледующееСлово(Текст, Курсор, Слово) Цикл
		
		Если Слово = """" и ПредыдущееСлово = """" Тогда
			Слово = Неопределено;
			ПредыдущееСлово = Неопределено;
		КонецЕсли;
		
		Если ПредыдущееСлово = """" Тогда
			Курсор=Курсор-1;
			Возврат;
		КонецЕсли;
		
		ПредыдущееСлово = Слово;
		
	КонецЦикла;
	
КонецПроцедуры
Процедура ОбойтиТекстДоСлова(Текст, Курсор, СловоВыхода)
	Слово = Неопределено;
	
	Пока СчитатьСледующееСлово(Текст, Курсор, Слово) Цикл
		
		Если Найти(" "+Символы.Таб+Символы.ПС+Символы.ВК, Слово)>0 Тогда
			Продолжить;
		ИначеЕсли Лев(Слово, 2) = "//" Тогда
			ОбойтиКомментарий(Текст, Курсор);
			Продолжить;
		ИначеЕсли Лев(Слово, 1) = """" Тогда
			ОбойтиСтроковуюКонстанту(Текст, Курсор, Слово);
			Продолжить;
		КонецЕсли;
		
		Если Слово = СловоВыхода Тогда
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры


Процедура ДобавитьМеткуВНачалоМетода(Текст, Курсор, Префикс)
	Слово = Неопределено;
	ИмяМетода = Неопределено;
	
	Пока СчитатьСледующееСлово(Текст, Курсор, Слово) Цикл
		
		Если Найти(" "+Символы.Таб+Символы.ПС+Символы.ВК, Слово)>0 Тогда
			Продолжить;
		ИначеЕсли Лев(Слово, 2) = "//" Тогда
			ОбойтиКомментарий(Текст, Курсор);
			Продолжить;
		ИначеЕсли Лев(Слово, 1) = "#" Тогда
			ОбойтиКомментарий(Текст, Курсор);
			Продолжить;
		ИначеЕсли Лев(Слово, 1) = """" Тогда
			ОбойтиСтроковуюКонстанту(Текст, Курсор, Слово);
			Продолжить;
		КонецЕсли;
		
		Если ИмяМетода = Неопределено Тогда
			Если Нрег(Слово) = Врег(Слово) Тогда
				Возврат;
			КонецЕсли;
				
			ИмяМетода = Слово;
		ИначеЕсли Слово = "(" Тогда
			ОбойтиТекстДоСлова(Текст, Курсор, ")");
		ИначеЕсли НРег(Слово) = "экспорт" Тогда
		ИначеЕсли НРег(Слово) = "перем" Тогда
			ОбойтиТекстДоСлова(Текст, Курсор, ";");
		Иначе
			ВставляемаяСтрока = Символы.ПС + "Оповестить(""*"", """+Префикс+ИмяМетода+"()"", Истина);" + Символы.ПС;
			Если НРег(ИмяМетода) = "обработкаоповещения" Тогда
				ВставляемаяСтрока = Символы.ПС+ "Если ИмяСобытия = ""*"" Тогда Возврат КонецЕсли; " +ВставляемаяСтрока;
			КонецЕсли;
			//Курсор = Курсор - СтрДлина(Слово) - 1;
			Курсор = Курсор - СтрДлина(Слово);
			ВставитьСтрокуВТекстИСместитьКурсор(Текст, Курсор, ВставляемаяСтрока);
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
Процедура ДобавитьМеткуВКонецМетода(Текст, Курсор, ТекущееСлово)
	
	ВставляемаяСтрока = Символы.ПС+";Оповестить(""*"", """", Ложь); "+Символы.ПС;
	Курсор = Курсор - СтрДлина(ТекущееСлово) - 1;
	ВставитьСтрокуВТекстИСместитьКурсор(Текст, Курсор, ВставляемаяСтрока);
	
	ОбойтиТекстДоСлова(Текст, Курсор, ТекущееСлово);
	
КонецПроцедуры
Процедура ВставитьСтрокуВТекстИСместитьКурсор(Текст, Курсор, ВставляемаяСтрока)
	Текст = Лев(Текст, Курсор) 
			+ ВставляемаяСтрока
			+ Сред(Текст, Курсор + 1);
	Курсор = Курсор + СтрДлина(ВставляемаяСтрока);
КонецПроцедуры



Функция СчитатьСледующееСлово(ТекстовыйПоток, Курсор, Слово)
	Слово = "";
	ИсходнаяПозиция = Курсор+1;
	Для Курсор = ИсходнаяПозиция По СтрДлина(ТекстовыйПоток) Цикл
		Символ = Сред(ТекстовыйПоток, Курсор, 1);
		
		Если Найти(";()|[]-=+*.,?&№#@!"+""""+Символы.ПС+Символы.ВК+Символы.Таб+" ",Символ)>0 Тогда
			Если Слово = "" Тогда
				Слово = Символ;
				Возврат Истина;
			Иначе
				Курсор=Курсор-1;
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если Символ = "/" Тогда
			Если Слово = "" Тогда
			ИначеЕсли Слово = "/" Тогда
				Слово = "//";
				Возврат Истина;
			Иначе
				Курсор=Курсор-1;
				Возврат Истина;
			КонецЕсли;
		КонецЕсли;
		
		Слово=Слово+Символ;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

#КонецОбласти

#Область _ // Подготовка перечня загружаемых файлов

Процедура СоздатьРеестрЗагружаемыхФайлов(КаталогРазобраннойКонфигурации) Экспорт
	Возврат;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	НайденныеФайлы = НайтиФайлы(КаталогРазобраннойКонфигурации, "*.bsl", Истина);
	Для Каждого Файл Из НайденныеФайлы Цикл
		ТекстовыйДокумент.ДобавитьСтроку(Файл.ПолноеИмя);
	КонецЦикла;
	
	РеестрЗагружаемыхФайлов = ПолучитьПутьКФайлуВСтандартномФормате(КаталогРазобраннойКонфигурации)
			+ ПолучитьРазделительПути()
			+ "Перечень загружаемых файлов.txt";
	ТекстовыйДокумент.Записать(РеестрЗагружаемыхФайлов);
КонецПроцедуры

#КонецОбласти

#Область _ // Загрузка файлов конфигурации

Процедура ЗагрузитьКонфигурациюИзФайлов(КаталогИБ, ПользовательИБ, КаталогРазобраннойКонфигурации, ПереченьЗагружаемыхФайлов) Экспорт
	Если ПустаяСтрока(КаталогИБ) Тогда
		Возврат;
	КонецЕсли;
	Команда = "%ПутьК1С%   DESIGNER  –force /F %КаталогИБ% "
		+ " /N %ПользовательИБ% "
		+ " /DisableStartupDialogs "
		+ " /LoadConfigFromFiles  %КаталогРазобраннойКонфигурации%"
		+ " -ListFile %ПереченьЗагружаемыхФайлов%";
		
	Команда = ПакетныйРежим.ОбернутьВКавычкиКоманду(Команда);
	
	Команда = СтрЗаменить(Команда, "%ПутьК1С%", КаталогПрограммы()+"1cv8.exe");
	Команда = СтрЗаменить(Команда, "%КаталогИБ%", КаталогИБ);
	Команда = СтрЗаменить(Команда, "%ПользовательИБ%", ПользовательИБ);
	Команда = СтрЗаменить(Команда, "%КаталогРазобраннойКонфигурации%", КаталогРазобраннойКонфигурации);
	Команда = СтрЗаменить(Команда, "%ПереченьЗагружаемыхФайлов%", ПереченьЗагружаемыхФайлов);
	
	ВыполнитьИзКоманднойСтроки(Команда);
КонецПроцедуры
Процедура ВыполнитьИзКоманднойСтроки(Команда) Экспорт
	
	КодВозврата = Неопределено;
	ЗапуститьПриложение(Команда, КаталогПрограммы(), Истина, КодВозврата);
	Если КодВозврата = Неопределено Тогда
		КодВозврата = "Неопределено";
	КонецЕсли;
	
	Сообщение = "[Код возврата: " + КодВозврата + "] : " + Команда;
	Сообщить(Сообщение);
	
	Если НЕ КодВозврата = 0 Тогда
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
КонецПроцедуры
Функция ОбернутьВКавычкиКоманду(знач Команда) Экспорт
	Команда = " " + Команда + " ";
	Команда = СтрЗаменить(Команда, " %", " ""%");
	Команда = СтрЗаменить(Команда, "% ", "%"" ");
	Возврат СокрЛП(Команда);
КонецФункции


#КонецОбласти

