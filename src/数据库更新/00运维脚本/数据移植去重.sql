

��ô����ȡ�ظ���¼
select * from table t1  where t1.rowed !=
(select max(rowed) from table t2 
where t1.id=t2.id and t1.name=t2.name)
����
select count(*), t.col_a,t.col_b from table t
group by col_a,col_b
having count(*)>1

�����ɾ���ظ���¼�����԰ѵ�һ������select�滻Ϊdelete;

���Ч��ɾ���ظ���¼���� ( ��Ϊʹ����ROWID) 

DELETE FROM EMP E 
 WHERE E.ROWID > (SELECT MIN(X.ROWID)  FROM EMP X WHERE X.EMP_NO = E.EMP_NO);

--�����м��,Ȼ��ɾ��rn�ֶΣ�
 create table offence_one as   select a.* from 
  select count(*) from 
   (select o.*,
               row_number() over(partition by num_plate, happen_time order by o.offence_id ) rn
          from offence o) a
 where a.rn =1;;
���
 insert into offence select * from offence_one ; 



������ھ͸��£������ھͲ��������һ�����ʵ����
[A]9i�Ѿ�֧���ˣ���Merge������ֻ֧��select�Ӳ�ѯ��
����ǵ������ݼ�¼������д��select ���� from dual���Ӳ�ѯ��
�﷨Ϊ��
MERGE INTO TAB_TO c
USING (SELECT course_name, period, course_hours FROM TAB_FROM) cu
ON (c.course_name = cu.course_name AND c.period = cu.period)
WHEN MATCHED THEN
  UPDATE SET c.course_hours = cu.course_hours
WHEN NOT MATCHED THEN
  INSERT
    (c.course_name, c.period, c.course_hours)
  VALUES
    (cu.course_name, cu.period, cu.course_hours);

