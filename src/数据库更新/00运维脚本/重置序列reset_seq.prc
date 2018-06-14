create or replace procedure reset_seq(user_name in varchar2 --�û���
                                      ) Authid Current_User AS

  cursor cur_tab is
    select t.TABLE_NAME, t.TABLESPACE_NAME --��ǰ�û�������
      from user_tables t
    --  upper(t.TABLESPACE_NAME) = upper(tablespace_name)
     where upper(t.TABLE_NAME) not in ('AREA') --���������ֶ��������ͱȽ�����
    -- and upper(t.TABLE_NAME) not like 'CMS_%'
     order by t.TABLE_NAME;

  strsql     varchar2(2000);
  v_seq_name varchar2(200);
  last_num   Integer;
  pk_col     varchar2(200); --������
  data_type  varchar2(200); --�������� NUMBER|VARCHAR
  id_col     Integer;

begin
  IF user_name is null then
    dbms_output.put_line('�����ò�����');
    return;
  end if;

  FOR v in cur_tab LOOP
  
    strsql := 'select max(decode(SEQUENCE_NAME,''COMMODITY_PACKAGE_CELL_DETAIL_S'',''PACKAGE_CELL_DETAIL_S'',SEQUENCE_NAME)) SEQUENCE_NAME from dba_sequences where
     upper(SEQUENCE_OWNER)=' || chr(39) || upper(user_name) ||
              chr(39) || '
              and
              upper(SEQUENCE_NAME)=
              replace(' || chr(39) ||
              upper(v.table_name || '_S') || chr(39) ||
              ',''COMMODITY_PACKAGE_CELL_DETAIL_S'',''PACKAGE_CELL_DETAIL_S'')'; --����������������
    --dbms_output.put_line('��ѯ���Ӧ�����У�'||chr(10)|| strsql);
    execute immediate strsql
      into v_seq_name;
  
    if v_seq_name is not null then
      strsql := 'drop sequence ' || v_seq_name;
      --dbms_output.put_line('ɾ�����У�' || strsql);
      execute immediate strsql;
    else
      /*      strsql:='select replace('||chr(39)||v.table_name || '_S'|| chr(39) ||',
                          ''COMMODITY_PACKAGE_CELL_DETAIL_S'',
                          ''PACKAGE_CELL_DETAIL_S'')  from dual';
           dbms_output.put_line('������'||strsql);
      */
      select replace(v.table_name || '_S',
                     'COMMODITY_PACKAGE_CELL_DETAIL_S',
                     'PACKAGE_CELL_DETAIL_S')
        into v_seq_name
        from dual;
    
    end if;
  
    select /*a.constraint_name,*/
     max(a.column_name)
      into pk_col
      from user_cons_columns a, user_constraints b
     where a.constraint_name = b.constraint_name
       and b.constraint_type = 'P'
       and a.table_name = upper(v.table_name);
  
    select max(c.data_type)
      into data_type
      from cols c
     where c.COLUMN_NAME = pk_col
       and c.table_name = upper(v.table_name);
  
    /*    dbms_output.put_line('��ǰ������' || v.table_name
    || ' ����:' || pk_col 
    || '���ͣ�'|| data_type
    || ' ��ǰ��������' || v_seq_name);*/
  
    if v_seq_name is not null and pk_col is not null and
       data_type = 'NUMBER' then
    
      strsql := 'select to_number(nvl(max(' || pk_col ||
                '),1)) next_num from ' || v.table_name;
    
      execute immediate strsql
        into last_num;
    
      strsql := 'create sequence ' || v_seq_name ||
                '  minvalue 1 maxvalue 9999999999999  start with ' ||
                (last_num + 1) || ' increment by 1 nocache';
      --dbms_output.put_line('��������'||v_seq_name||'��ʼֵ��'||(last_num + 1));
      execute immediate strsql;
    
    else
      select count(1)
        into id_col
        from cols c
       where upper(c.COLUMN_NAME) = 'ID'
         and c.table_name = upper(v.table_name);
    
      select max(c.data_type)
        into data_type
        from cols c
       where upper(c.COLUMN_NAME) = 'ID'
         and c.table_name = upper(v.table_name);
         
      if id_col = 1 and data_type = 'NUMBER' then
        strsql := 'select to_number(nvl(max(ID),1)) next_num from ' || v.table_name;
      
        execute immediate strsql
          into last_num;
      
        strsql := 'create sequence ' || v_seq_name ||
                  '  minvalue 1 maxvalue 9999999999999  start with ' ||
                  (last_num + 1) || ' increment by 1 nocache';
        execute immediate strsql;
      else
      
        dbms_output.put_line('����û�����á���ǰ������' || v.table_name || ' ����:' ||
                             pk_col || '���ͣ�' || data_type);
      end if;
    end if;
  
  END LOOP;

EXCEPTION
  when others then
    rollback;
    dbms_output.put_line('ִ�У�' || strsql || ' ����' || chr(10));
    dbms_output.put_line(SQLERRM);
  
end;
/
