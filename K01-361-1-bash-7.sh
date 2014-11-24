#!/bin/bash
2> stderr
echo "Программа поиска пользователей"
echo "С помощью данной программы вы можете произвести определить принадлежность пользователя группам по его имени."
echo ""
echo "Разработчик: Аринчёхина Юлия"
cont="y"
>us_ex
until [[ -s us_ex || "$cont" = "n" ]]; do 
	if [ "$cont" = "y" ]; then
		echo ""
		echo "Введите имя пользователя:"
		read us_name
		cut -d: -f1 /etc/passwd | grep ^$us_name$ >us_ex
	fi	
	if [ ! -s us_ex ]; then
		echo ""
		echo "Такого пользователя нет."
		echo ""
		echo "Хотите продолжить? (y/n)"
		read cont
	fi
done
if [ ! "$cont" = "n" ]; then
	>group_list; >group_main;
	cut -d: -f1,4 /etc/group | grep $us_name | cut -d: -f1 >group_list
	group_main_num=$(cut -d: -f1,4 /etc/passwd | grep $us_name | cut -d: -f2) #Запись в переменную
	touch group_main_num_grep
	group_main_num_grep=':'${group_main_num}
	cut -d: -f1,3 /etc/group | grep $group_main_num_grep | cut -d: -f1 >group_main
	diff group_main group_list >group_nmain_list 	
	>group_nmain_list_res
	cut -s -d' ' -f2 group_nmain_list >group_nmain_list_res
	echo ""
	echo "Основная группа:"
	cat group_main
	if [  -s group_nmain_list_res ]; then
		echo "Остальные группы:"
		cat group_nmain_list_res
	else 
		echo "Пользователь состоит только в одной группе."
	fi
else
	if [[ ! -s us_ex && "$cont" = "n" ]]; then
		echo "...завершается..."
		exit 250
	else
		echo "...завершается..."
	fi
fi