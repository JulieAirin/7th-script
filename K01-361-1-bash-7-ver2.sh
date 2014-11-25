#!/bin/bash
#2>stderr #Разобрать, если понадобится.
echo "Программа поиска пользователей"
echo "С помощью данной программы вы можете произвести определить принадлежность пользователя группам по его имени."
echo ""
echo "Разработчик: Аринчёхина Юлия"
cont="y"
>us_ex
until [[ -s us_ex || "$cont" = "n" ]]; do 
	echo ""
	echo "Введите имя пользователя:"
	read us_name
	getent passwd ${us_name} >us_ex	#Ищем пользователя
	if [ ! -s us_ex ]; then #Проверяем его наличие
		echo ""
		echo "Такого пользователя нет."
		echo ""
		echo "Хотите продолжить? (y/n)"
		read cont
		if [ "$cont" = "n" ]; then 
			echo "...завершается..."
			exit 250
		fi
	fi
done
>group_list; >group_main; >group_main_num_grep;  #Обнуляем/создаём файлы (далее для сравнения нужны именно переменные, а не файлы)
us_name_grep=':'${us_name} #Модифицируем для поиска
cut -d: -f1,4 /etc/group | grep $us_name_grep | cut -d: -f1 >group_list #Получаем список всех групп для нашего пользователя
group_main_num=$(cut -d: -f1,4 /etc/passwd | grep ^$us_name | cut -d: -f2) #Вытаскиваем номер основной группы
group_main_num_grep=':'${group_main_num} #Модифицируем, чтобы использовать значение в grep'е
cut -d: -f1,3 /etc/group | grep $group_main_num_grep | cut -d: -f1 >group_main #Вытаскиваем имя основной группы 
echo ""
echo "Основная группа:"
cat group_main
if [  -s group_list ]; then
	echo "Остальные группы:"
	cat group_list
else 
	echo "Пользователь состоит только в одной группе."
fi		
