[Q]��ôʵ��һ����¼��������������
[A]9i���Ͽ���ͨ��Insert all�����ɣ�������һ����䣬�磺
INSERT ALL
WHEN (id=1) THEN
INTO table_1 (id, name)
values(id,name)
WHEN (id=2) THEN
INTO table_2 (id, name)
values(id,name)
ELSE
INTO table_other (id, name)
values(id, name)
SELECT id,name
FROM a;
���û�������Ļ��������ÿ����Ĳ��룬��
INSERT ALL
INTO table_1 (id, name)
values(id,name)
INTO table_2 (id, name)
values(id,name)
INTO table_other (id, name)
values(id, name)
SELECT id,name
FROM a;