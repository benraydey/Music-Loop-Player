unit uProjects;

interface

uses SysUtils;

{ Projects Class defines projects objects that store
 an ID, name, last saved date and tempo for each project.
 Projects are created, accessed and deleted by users.}

type TProjects = class
  private
    ProjectID : integer;
    ProjectName,
    LastSavedDate : string;
    Tempo : integer;
  public
    {Instantiates Object}
    Constructor Create (id : integer; na : string; te : integer; da : string);
    function getTempo : integer;    {Returns the project's tempo as an integer.}
    function getProjectName : string; {Returns the project's name as a string.}
    function getProjectID : integer;  {Returns the project's id as an integer.}
    procedure setTempo (te : integer); {Updates the projects tempo. Reads in an integer.}
    procedure setProjectName (na : string); {Updates the project's name. Reads in a string.}
    procedure setLastSavedDate (da : string); {Updates the last saved date of the project.}
    function toString : string;       {Returns the project's last saved date as a string.}
end;

implementation

{ TProjects }

constructor TProjects.Create(id : integer; na: string; te: integer; da : string);
begin
  ProjectID := id;
  ProjectName := na;      {Instantiates object}
  Tempo := te;
  LastSavedDate := da;
end;

function TProjects.getTempo: Integer;
begin
  Result := Tempo;           {Returns the project's tempo as an integer.}
end;

function TProjects.getProjectID: integer;
begin
  Result := ProjectID        {Returns the project's id as an integer.}
end;

function TProjects.getProjectName: string;
begin
  Result := ProjectName;     {Returns the project's name as a string.}
end;

procedure TProjects.setLastSavedDate(da: string);
begin
  LastSavedDate := da;       {Updates the last saved date of the project.}
end;

procedure TProjects.setTempo(te: integer);
begin
  Tempo := te;               {Updates the projects tempo. Reads in an integer.}
end;

procedure TProjects.setProjectName(na: string);
begin
  ProjectName := na;         {Updates the project's name. Reads in a string.}
end;

function TProjects.toString: string;
begin
  Result := LastSavedDate;   {Returns the project's last saved date as a string.}
end;

end.
 