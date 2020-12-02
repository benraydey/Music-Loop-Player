unit uProjectsArray;

interface

uses uProjects, ADODB, DB, SysUtils, Classes, Dialogs, uButtons, Graphics;

{Projects Array class communicates with the application's database and
 updates data related to a specific project.}

type TProjectsArray = class
  private
    conn : TADOConnection;
  public
    Constructor Create(db : string);    {Instantiates object. Connects to the database}
    function getProjects : TStringList;    {Returns a stringlist of all the project objects}
    function getSceneDescription(id, sc : Integer) : String; {Returns the scene description for one of eight scenes of a specificied project}
    procedure newProject (p : TProjects);    {Creates a new project in the database}
    procedure deleteProject(pid : Integer);  {Removes all data related to the specified project from the database}
    procedure saveName (id : integer; na : string); {Updates the name of a project in the database}
    procedure saveProject (id : integer);    {Updates the data related to a single specified project in the database}
    procedure saveTempo (te, id : integer);  {Updates the tempo of a specified project in the database}
    procedure saveSceneDescriptions (id, sc : integer; de : string); {Updates the scene description of one of eight scenes for a specified project in the database}

end;

implementation

uses Unit1;

{ TProjectsArray }

constructor TProjectsArray.Create(db: string);
begin
  {Instantiates object. Connects to the database}
  conn := TADOConnection.Create(NIL);
  conn.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;Extended Properties="DBQ=' + db + ';Driver={Driver do Microsoft Access (*.mdb)};DriverId=25;FIL=MS Access;FILEDSN=C:\Program Files\Common Files\ODBC\Data Sources\Test.dsn;MaxBufferSize=2048;MaxScanRows=8;PageTimeout=5;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;"';
end;

procedure TProjectsArray.deleteProject(pid: Integer);
var
  SQLq : string;
  query : TADOQuery;
  sl : TStringList;
begin

  {Removes all data related to the specified project from the database}

    SQLq := 'DELETE * FROM tblProjects WHERE ProjectID = ' + IntToStr(pid);

    query := TADOQuery.Create(NIL);
    query.Connection := conn;
    query.Sql.Add(sqlQ);

    query.ExecSQL;

    query.Close;

  {Delete button data}

    SQLq := 'DELETE * FROM tblButtons WHERE ProjectID = ' + IntToStr(pid);

    query := TADOQuery.Create(NIL);
    query.Connection := conn;
    query.Sql.Add(sqlQ);

    query.ExecSQL;

    query.Close;

  {Delete scene description data}

    SQLq := 'DELETE * FROM tblRows WHERE ProjectID = ' + IntToStr(pid);

    query := TADOQuery.Create(NIL);
    query.Connection := conn;
    query.Sql.Add(sqlQ);

    query.ExecSQL;

    query.Close;

  {Delete notepad data}
  
    DeleteFile(GetCurrentDir + '\Resources\Note Files\' + IntToStr(pid) + '.txt') ;


end;

function TProjectsArray.getProjects: TStringList;
var
  SQLq : string;
  query : TADOQuery;
  p : TProjects;
  sl : TStringList;
begin

{Returns a stringlist of all the project objects}

  SQLq := 'SELECT * FROM tblProjects ORDER BY ProjectID ASC';

    query := TADOQuery.Create(NIL);
    query.Connection := conn;
    query.SQL.Add(sqlQ);
    query.Active := true;

  sl := TStringList.Create;

  While NOT query.Eof do
    begin
      p := TProjects.Create(query.FieldValues['ProjectID'],
                            query.FieldValues['ProjectName'],
                            query.FieldValues['Tempo'],
                            query.FieldValues['LastSavedDate']);
      sl.AddObject(p.getProjectName, p);
      query.Next;
    end;

  query.Active := false;

  query.Close;

  Result := sl;

end;

function TProjectsArray.getSceneDescription(id, sc: Integer): String;
var
  SQLq : String;
  query : TADOQuery;
begin

{Returns the scene description for one of eight scenes of a specificied project}

  //Fetch the scene description from the database
  //scene description number = "sc"

  SQLq := 'SELECT SceneDescription FROM tblRows WHERE ProjectID = ' + IntToStr(id) + ' AND SceneID = ' + IntToStr(sc);

  query := TADOQuery.Create(NIL);
  query.Connection := conn;
  query.SQL.Add(sqlQ);
  query.Active := true;

  Result := query.FieldValues['SceneDescription'];

end;

procedure TProjectsArray.newProject(p: TProjects);
var
  SQLq : String;
  query : TADOQuery;
  i : integer;
  id : integer;
begin

{Creates a new project in the database}


{SQL Query}
  sqlQ := 'INSERT INTO tblProjects (ProjectName, Tempo, LastSavedDate) VALUES (';

  SQLq := SQLq + '''' + p.getProjectName;
  SQLq := SQLq + ''', ''' + '120';
  SQLq := SQLq + ''', #' + p.toString + '#)';

  query := TADOQuery.Create(NIL);
  query.Connection := conn;
  query.Sql.Add(sqlQ);

  query.ExecSQL;

  query.Close;

  {Fetch the autonumber-created id of the new project}

{SQL Query}
  SQLq := 'SELECT ProjectID FROM tblProjects ORDER BY ProjectID DESC';

    query := TADOQuery.Create(NIL);
    query.Connection := conn;
    query.SQL.Add(sqlQ);
    query.Active := true;

  id := query.FieldValues['ProjectID'];

  for i := 1 to 64 do               {Create a blank project}
    begin
      sqlQ := 'INSERT INTO tblButtons (ProjectID, ButtonID, SampleID) VALUES (';
      sqlQ := sqlQ + IntToStr(id)
              + ', ' + IntToStr(i)
              + ', 0);' ;

      query := TADOQuery.Create(NIL);
      query.Connection := conn;
      query.Sql.Add(sqlQ);

      query.ExecSQL;

      query.Close;
    end;

  {Create new scene descriptions for the new project}

  for i := 1 to 8 do
    begin
      sqlQ := 'INSERT INTO tblRows (ProjectID, SceneID, SceneDescription) VALUES (';
      sqlQ := sqlQ + IntToStr(id)
              + ', ' + IntToStr(i)
              + ',' + '''Scene Description ' + IntToStr(i) + ''' );' ;

      query := TADOQuery.Create(NIL);
      query.Connection := conn;
      query.Sql.Add(sqlQ);

      query.ExecSQL;

      query.Close;
    end;

end;

procedure TProjectsArray.saveName(id: integer; na: string);
var
  SQLq : String;
  query : TADOQuery;
begin

  {Updates the name of a project in the database}

{SQL Query}
  SQLq := 'UPDATE tblProjects SET ProjectName = ' + '''' + na + '''' + ' WHERE ProjectID = ' + IntToStr(id);

  query := TADOQuery.Create(NIL);
  query.Connection := conn;
  query.Sql.Add(SQLq);

  query.ExecSQL;

  query.Close;

  SQLq := 'UPDATE tblProjects SET LastSavedDate = #' + FormatDateTime('yyyy/mm/dd',Date) + '# WHERE ProjectID = ' + IntToStr(id);

  query := TADOQuery.Create(NIL);
  query.Connection := conn;
  query.Sql.Add(SQLq);

  query.ExecSQL;

  query.Close;

end;

procedure TProjectsArray.saveProject (id : integer);
var
  SQLq : string;
  query : TADOQuery;
  i : integer;
  b : TButtons;
begin

{Updates the data related to a single specified project in the database}


  {Update button data}
  for i := 1 to 64 do
    begin
      b := Unit1.buttons[i].data;
      SQLq := 'UPDATE tblButtons SET sampleID = ' + IntToStr(b.getID) + ' WHERE ProjectID = ' + IntToStr(id) + ' AND ButtonID = ' + IntToStr(i);

      query := TADOQuery.Create(NIL);
      query.Connection := conn;          {Query tblButtons to save button }
      query.SQL.Add(SQLq);               {    configuration               }

      query.ExecSQL;

      query.Close;
    end;

   //Update save button to indicate that project has been saved
   Unit1.saveEnabled := False;
   frmSampleLaunchPad.btnSave.Font.Color := clGray;

end;

procedure TProjectsArray.saveTempo(te, id : integer);
var
  SQLq : String;
  query : TADOQuery;
begin

  {Updates the data related to a single specified project in the database}

{SQL Query}      {Update the Project's Tempo}
  SQLq := 'UPDATE tblProjects SET Tempo = ' + '''' + IntToStr(te) + '''' + ' WHERE ProjectID = ' + IntToStr(id);

  query := TADOQuery.Create(NIL);
  query.Connection := conn;
  query.Sql.Add(SQLq);

  query.ExecSQL;

  query.Close;

{SQL Query}      {Update the Project's Last Saved Date}
  SQLq := 'UPDATE tblProjects SET LastSavedDate = #' + FormatDateTime('yyyy/mm/dd',Date) + '# WHERE ProjectID = ' + IntToStr(id);

  query := TADOQuery.Create(NIL);
  query.Connection := conn;
  query.Sql.Add(SQLq);

  query.ExecSQL;

  query.Close;  


end;

procedure TProjectsArray.saveSceneDescriptions (id, sc : integer; de : string);
var
  SQLq : String;
  query : TADOQuery;
begin

  {Updates the scene description of one of eight scenes for a specified project in the database}

{SQL Query}
  SQLq := 'UPDATE tblRows SET SceneDescription = ' + '''' + de + '''' + ' WHERE ProjectID = ' + IntToStr(id) + ' AND SceneID = ' + IntToStr(sc) + ';' ;

  query := TADOQuery.Create(NIL);
  query.Connection := conn;
  query.Sql.Add(SQLq);

  query.ExecSQL;

  query.Close;

end;

end.
