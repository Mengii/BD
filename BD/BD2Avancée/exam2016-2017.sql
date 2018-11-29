create or replace traitament (f varchar2) is
    cursor c is
        select idc from demande where statut = 'ignore';
    l_idc int;
    texte varchar2(100);
    numero_tel varchar2(10);
begin
    open c;
    fetch c into l_idc;
    while c%found loop
        dbms_output.put_line('les identifiants selectes'||l_idc);
        fetch c into l_idc;
        texte := 'begin :1 := '||f||'('||l_idc||'); end;';
        dbms_output.put_line(texte);
        execute immediate texte using out numero_tel;
        dbms_output.put_line(numero_tel);
    end loop;
    close c;
end;
/


demande(30,1, Berlin, ignoré)
demande(31,2, SaintTrop, ignoré)
demande(32,3, Lille, ignoré)

client(1, Riton, 0612345678)
client(2, Jean, 0722345678)
client(1, Jeanne, 0622345678)

set serveroutput on
exec traitament ('traitement1');

affichage des résultats :
0612345678
0722345678
0622345678


