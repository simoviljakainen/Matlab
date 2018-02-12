function [data] = sqlQuery(wData, wAttr, table)
    prefs = setdbprefs('DataReturnFormat');
    setdbprefs('DataReturnFormat','table')

    % Make connection to database
    conn = database('smliiga','root','','Vendor','MYSQL','Server','localhost','PortNumber',3306);

    % Execute query and fetch results
    curs = exec(conn,[sprintf('SELECT %s FROM smliiga.%s %s ',...
        strjoin(wData,','),table,join(wAttr))]);
    
    curs = fetch(curs);
    data = curs.Data;
    close(curs);

    % Close connection to database
    close(conn)

    % Restore preferences
    setdbprefs('DataReturnFormat',prefs);

    % Clear variables
    clear prefs conn curs;
end

