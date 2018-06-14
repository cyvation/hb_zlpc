--1.��β鿴session���ĵȴ��¼���
/*==============================================================================
�����Ƕ����ݿ�����ܽ��е���ʱ��һ������Ҫ�Ĳο�ָ�����ϵͳ�ȴ��� ����
$system_event,v$session_event,v$session_wait��������ͼ���¼�ľ���ϵͳ����session���ĵȴ� �¼���
ͨ����ѯ��Щ��ͼ����Է������ݿ��һЩ���������ڵȴ�ʲô���Ǵ���I/O��������æ�����ǲ����ȵȡ�

ͨ������sql����Բ�ѯ���ÿ��Ӧ�ó��򵽵��ڵȴ�ʲô���Ӷ������Щ��Ϣ�����ݿ�����ܽ��е�����
==============================================================================*/
Select s.username,s.program,s.status,se.event,se.total_waits,se.total_timeouts,se.time_waited,se.average_wait 
from v$session s, v$session_event se Where s.sid=se.sid And se.event not like 'SQl*Net%' 
And s.status ='ACTIVE' And s.username is not NULL;
/*==============================================================================
2.oracle�в�ѯ�����ı��ͷ�session
==============================================================================*/
SELECT A.OWNER,
A.OBJECT_NAME,
B.XIDUSN,
B.XIDSLOT,
B.XIDSQN,
B.SESSION_ID,
B.ORACLE_USERNAME,
B.OS_USER_NAME,
B.PROCESS,
B.LOCKED_MODE,
C.MACHINE,
C.STATUS,
C.SERVER,
C.SID,
C.SERIAL#,
C.PROGRAM
FROM ALL_OBJECTS A, V$LOCKED_OBJECT B, SYS.GV_$SESSION C
WHERE (A.OBJECT_ID = B.OBJECT_ID)
AND (B.PROCESS = C.PROCESS)
ORDER BY 1, 2;

--�ͷ�session Sql:
alter system kill session 'sid, serial#';

alter system kill session '30, 2412';
/*==============================================================================
�磺
alter system kill session '379, 21132'
alter system kill session '374, 6938'
==============================================================================*/

/*==============================================================================
3.�鿴ռ��ϵͳio�ϴ��session
==============================================================================*/
SELECT se.sid,
se.serial#,
pr.SPID,
se.username,
se.status,
se.terminal,
se.program,
se.MODULE,
se.sql_address,
st.event,
st.p1text,
si.physical_reads,
si.block_changes
FROM v$session se, ��v$session_wait st, v$sess_io si, v$process pr
WHERE st.sid = se.sid ��AND st.sid = si.sid
AND se.PADDR = pr.ADDR
AND se.sid > 6��AND st.wait_time = 0
AND st.event NOT LIKE '%SQL%'
ORDER BY physical_reads DESC;

/*==============================================================================
4.�ҳ���cpu�϶��session
==============================================================================*/
select a.sid,spid,status,substr(a.program,1,40) prog,a.terminal,osuser,value/60/100 value
from v$session a,v$process b,v$sesstat c
where c.statistic#=12 and c.sid=a.sid and a.paddr=b.addr order by value desc;

/*==============================================================================
5.��ѯsession������sql������һ�����
==============================================================================*/
select sys.v_$session.osuser,sys.v_$session.machine,v$lock.sid,
����sys.v_$session.serial#,
����decode(v$lock.type,
����'MR', 'Media Recovery',
����'RT','Redo Thread',
����'UN','User Name',
����'TX', 'Transaction',
����'TM', 'DML',
����'UL', 'PL/SQL User Lock',
����'DX', 'Distributed Xaction',
����'CF', 'Control File',
����'IS', 'Instance State',
����'FS', 'File Set',
����'IR', 'Instance Recovery',
����'ST', 'Disk Space Transaction',
����'TS', 'Temp Segment',
����'IV', 'Library Cache Invalida-tion',
����'LS', 'Log Start or Switch',
����'RW', 'Row Wait',
����'SQ', 'Sequence Number',
����'TE', 'Extend Table',
����'TT', 'Temp Table',
����'Unknown') LockType,
����rtrim(object_type) || ' ' || rtrim(owner) || '.' || object_name object_name,
����decode(lmode, 0, 'None',
����1, 'Null',
����2, 'Row-S',
����3, 'Row-X',
����4, 'Share',
����5, 'S/Row-X',
����6, 'Exclusive', 'Unknown') LockMode,
����decode(request, 0, 'None',
����1, 'Null',
����2, 'Row-S',
����3, 'Row-X',
����4, 'Share',
����5, 'S/Row-X',
����6, 'Exclusive', 'Unknown') RequestMode,
����ctime, block b
����from v$lock, all_objects, sys.v_$session
����where v$Lock.sid > 6 and sys.v_$session.sid = v$lock.sid 
����and v$lock.id1 = all_objects.object_id;
����
/*==============================================================================
OSһ��for kill ����Oracle��ɱ��������
����������������ɱ��һ�����̺󣬽���״̬����Ϊ"killed"��������������Դ�ܳ�ʱ��û�б��ͷţ�
��ô������osһ����ɱ����Ӧ
==============================================================================*/
--1 ��ѯsession������sql,��Ҫ��ѯ,�õ�SID
select object_name,machine,s.sid,s.serial# 
from v$locked_object l,dba_objects o ,v$session s
where l.object_id��=��o.object_id and l.session_id=s.sid;

--2 ʹ��alter system kill session '24,111'; (����24,111�ֱ��������ѯ����sid,serial#)�����ͷ�
alter system kill session '30, 2412'

--3 ִ�����������ý��̣��̣߳���,sidΪ��һ����ѯ����sid�ţ�
select spid, osuser, s.program 
from v$session s,v$process p
where s.paddr=p.addr and s.sid=30; 
/*==============================================================================
4.��OS��ɱ��������̣��̣߳���
1)��unix�ϣ���root���ִ������: 
#kill -9 12345������3����ѯ����spid��
2)��windows��unixҲ���ã���orakillɱ���̣߳�orakill��oracle�ṩ��һ����ִ������﷨Ϊ��
orakill sid thread
���У�
sid����ʾҪɱ���Ľ������ڵ�ʵ����
thread����Ҫɱ�����̺߳ţ�����3����ѯ����spid��
����c:>orakill orcl 12345
