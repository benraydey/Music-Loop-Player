unit Start;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, ComCtrls, uProjects, uProjectsArray, uSampleLibrary,
  Buttons, ExtCtrls, Spin;

type
  TfrmStartMenu = class(TForm)
    liProjects: TListBox;
    edtProjectName: TEdit;
    btnSaveName: TButton;
    lblLastSaved: TLabel;
    lblLastSavedDate: TLabel;
    pnlMenu: TPanel;
    lblProjectName: TLabel;
    pnlHeader: TPanel;
    btnLoadProject: TPanel;
    btnDeleteProject: TPanel;
    btnNewProject: TPanel;
    lblTitle: TLabel;
    spnedtTempo: TSpinEdit;
    lblTempo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure liProjectsClick(Sender: TObject);
    procedure btnSaveNameClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnLoadProjectClick(Sender: TObject);
    procedure liProjectsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnLoadClick(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure btnNewProjectClick(Sender: TObject);
    procedure ButtonDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnLoadProjectMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure spnedtTempoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pID : integer;
  end;

var
  frmStartMenu: TfrmStartMenu;
  tempoChanged : Boolean;


implementation

uses Unit1;

{$R *.dfm}

procedure TfrmStartMenu.FormCreate(Sender: TObject);
var
  projectDB : TProjectsArray;
  p : TProjects;
begin

  


end;

procedure TfrmStartMenu.liProjectsClick(Sender: TObject);
var
  projectDB : TProjectsArray;
  p : TProjects;
  pos : integer;
begin

  projectDB := TProjectsArray.Create('db.mdb');

  //Save tempo of previously selected project if necessary
  If tempoChanged = True then
    begin
      projectDB.saveTempo(spnedtTempo.Value, pID);
    end;

  //Refill list box for OnDrawItem to activate
  pos := liProjects.ItemIndex;
  liProjects.Items := projectDB.getProjects;
  liProjects.ItemIndex := pos;

  p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;

  edtProjectName.Text := p.getProjectName;
  lblLastSavedDate.Caption := p.toString;
  pID := p.getProjectID;
  lblProjectName.Caption := p.getProjectName;
  lblProjectName.Width := 145;
  lblProjectName.WordWrap := True;
  spnedtTempo.Value := p.getTempo;

  tempoChanged := False;

end;

procedure TfrmStartMenu.btnSaveNameClick(Sender: TObject);
var
  na : string;
  p : TProjects;
  projectDB : TProjectsArray;
  index : integer;
begin
  index := liProjects.ItemIndex;

  p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;
  projectDB := TProjectsArray.Create('db.mdb');
  na := edtProjectName.Text;
  projectDB.saveName(p.getProjectID, na);
  liProjects.Items := projectDB.getProjects;

  liProjects.ItemIndex := index;

  p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;  //Select the nearest project
  edtProjectName.Text := p.getProjectName;                           //  and fill in its info
  lblLastSavedDate.Caption := p.toString;
  pID := p.getProjectID;
  lblProjectName.Caption := p.getProjectName;
  lblProjectName.Width := 145;
  lblProjectName.WordWrap := True;

end;

procedure TfrmStartMenu.btnDeleteClick(Sender: TObject);
var
  p : TProjects;
  projectDB : TProjectsArray;
  index : integer;
begin

  index := liProjects.ItemIndex;

  p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;
  projectDB := TProjectsArray.Create('db.mdb');
  projectDB.deleteProject(p.getProjectID);
  liProjects.Items := projectDB.getProjects;

  If index = liProjects.Items.Count then
    begin
      liProjects.ItemIndex := index - 1;              //SELECT THE CLOSEST PROJECT

      p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;  //Select the nearest project
      edtProjectName.Text := p.getProjectName;                           //  and fill in its info
      lblLastSavedDate.Caption := p.toString;
      pID := p.getProjectID;
    end

  else
    begin
      liProjects.ItemIndex := index;
      p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;  //Select the nearest project
      edtProjectName.Text := p.getProjectName;                           //  and fill in its info
      lblLastSavedDate.Caption := p.toString;
      pID := p.getProjectID;
    end;

end;

procedure TfrmStartMenu.btnLoadProjectClick(Sender: TObject);
begin

  //Open Sample library and Sample Launch Pad
  //        and close Start Menu
  frmSampleLibrary.Visible := True;
  frmSampleLaunchPad.Show;
  frmStartMenu.Visible := False;


end;


procedure TfrmStartMenu.liProjectsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Colours: array[1..2] of integer;
begin
  //Create alternating colours in list boxes

  Colours[1] := clMedGray;
  Colours[2] := clSilver;


  if index = liProjects.ItemIndex then
    begin
      with (Control as TListBox).Canvas do
      begin                                            {Selected project is highlighted Sky Blue}
        Brush.Color := clSkyBlue;
        FillRect(Rect);
        TextOut(Rect.Left,Rect.Top,liProjects.Items[index]);
      end;
    end
  else
    begin
      with (Control as TListBox).Canvas do
      begin
        Brush.Color := Colours[(Index+1) MOD 2 + 1];
        FillRect(Rect);
        TextOut(Rect.Left,Rect.Top,liProjects.Items[index]);
      end;
    end;

end;

procedure TfrmStartMenu.btnLoadClick(Sender: TObject);
var
  projectDB : TProjectsArray;
begin
  projectDb := TProjectsArray.Create('db.mdb');

  //Save tempo of previously selected project if necessary
  If tempoChanged = True then
    begin
      projectDB.saveTempo(spnedtTempo.Value, pID);
    end;

  //Open Sample library and Sample Launch Pad
  //        and close Start Menu
  frmSampleLibrary.Visible := True;
  frmSampleLaunchPad.Show;
  frmStartMenu.Visible := False;


  tempoChanged := False;


end;

procedure TfrmStartMenu.Panel3Click(Sender: TObject);
var
  p : TProjects;
  projectDB : TProjectsArray;
  index : integer;
  sure : integer;
begin

  index := liProjects.ItemIndex;
  sure := MessageDlg( 'Are you sure you want to delete ' + '''' + lblProjectName.Caption + '''', mtCustom, [mbYes, mbNo], 0);

  if sure = mrYes then
    begin
      p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;
      projectDB := TProjectsArray.Create('db.mdb');
      projectDB.deleteProject(p.getProjectID);
      liProjects.Items := projectDB.getProjects;

      If liProjects.Items.Count > 0 then   {check if any projects exist}
        begin
          If index = liProjects.Items.Count then
            begin
              liProjects.ItemIndex := index - 1;              //SELECT THE CLOSEST PROJECT
              p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;  //Select the nearest project
              edtProjectName.Text := p.getProjectName;                           //  and fill in its info
              lblLastSavedDate.Caption := p.toString;
              pID := p.getProjectID;
              lblProjectName.Caption := p.getProjectName;
              lblProjectName.Width := 145;
              lblProjectName.WordWrap := True;
              spnedtTempo.Value := p.getTempo;
            end
          else
            begin
              liProjects.ItemIndex := index;
              p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;  //Select the nearest project
              edtProjectName.Text := p.getProjectName;                           //  and fill in its info
              lblLastSavedDate.Caption := p.toString;
              pID := p.getProjectID;
              lblProjectName.Caption := p.getProjectName;
              lblProjectName.Width := 145;
              lblProjectName.WordWrap := True;
              spnedtTempo.Value := p.getTempo;
            end;
        end
          else
            begin
              btnLoadProject.Enabled := False;
              btnDeleteProject.Enabled := False;
              btnLoadProject.Color := clSilver;      {Disable components if no projects}
              btnDeleteProject.Color := clSilver;
              btnLoadProject.Font.Color := clGrayText;
              btnDeleteProject.Font.Color := clGrayText;
              lblLastSavedDate.Visible := False;
              btnSaveName.Enabled := False;
              edtProjectName.Enabled := False;
              spnedtTempo.Enabled := False;
              liProjects.Enabled := False;
              lblProjectName.Caption := '';
            end;
    end;

  tempoChanged := False;

end;

procedure TfrmStartMenu.btnNewProjectClick(Sender: TObject);
var
  p : TProjects;
  projectDB : TProjectsArray;
  allProjects : TStringList;
  count,
  index, i : integer;
  name, temp : string;
begin
  projectDB := TProjectsArray.Create('db.mdb');

  //Save tempo of previously selected project if necessary
  If tempoChanged = True then
    begin
      projectDB.saveTempo(spnedtTempo.Value, pID);
    end;

  count := liProjects.Items.Count;

  allProjects := projectDB.getProjects;

  if allProjects.Find('New Project', index) then
    begin
      temp := 'New Project';
      i := 0;
      While allProjects.Find(temp, index) do
        begin
          inc(i);                                       {Check if New Name 1, New Name 2 etc. exist and increment New Name i accordingly}
          temp := 'New Project ' + IntToStr(i);
          ShowMessage(IntToStr(i)) ;
        end;
      name := temp;
    end
  else
    begin
      name := 'New Project';
    end;
    
  p := TProjects.Create (1, name, 120, FormatDateTime('yyyy/mm/dd',Date));

  projectDB.newProject(p);

  liProjects.Items := projectDB.getProjects;

  liProjects.ItemIndex := count;
  p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;  //Select the new project
  edtProjectName.Text := p.getProjectName;                           //  and fill in its info
  lblLastSavedDate.Caption := p.toString;
  pID := p.getProjectID;
  lblProjectName.Caption := p.getProjectName;
  lblProjectName.Width := 145;
  lblProjectName.WordWrap := True;
  spnedtTempo.Value := p.getTempo;

  btnLoadProject.Enabled := True;
  btnDeleteProject.Enabled := True;
  btnLoadProject.Color := $00A66F09;
  btnDeleteProject.Color := $00A66F09;
  btnLoadProject.Font.Color := clInactiveCaption;
  btnDeleteProject.Font.Color := clInactiveCaption;
  lblLastSavedDate.Visible := True;
  btnSaveName.Enabled := True;                              {Re-enable components}
  edtProjectName.Enabled := True;
  spnedtTempo.Enabled := True;
  liProjects.Enabled := True;

  tempoChanged := False;


end;

procedure TfrmStartMenu.ButtonDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TPanel).BevelInner := bvLowered;  {Panel click animation}
  (Sender as TPanel).BevelOuter := bvLowered;
end;

procedure TfrmStartMenu.btnLoadProjectMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TPanel).BevelInner := bvRaised;   {Panel click animation}
  (Sender as TPanel).BevelOuter := bvRaised;
end;

procedure TfrmStartMenu.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  projectDB : TProjectsArray;
begin
  projectDb := TProjectsArray.Create('db.mdb');
  
  //Save tempo of previously selected project if necessary
  If tempoChanged = True then
    begin
      projectDB.saveTempo(spnedtTempo.Value, pID);
    end;  
end;

procedure TfrmStartMenu.spnedtTempoChange(Sender: TObject);
begin
  tempoChanged := True;
end;

procedure TfrmStartMenu.FormShow(Sender: TObject);
var
  projectDB : TProjectsArray;
  p : TProjects;
begin
  tempoChanged := False;

  projectDB := TProjectsArray.Create('db.mdb');

  liProjects.Items := projectDB.getProjects;

  If liProjects.Items.Count > 0 then
    begin
      liProjects.ItemIndex := 0;

      p := liProjects.Items.Objects[liProjects.ItemIndex] as TProjects;

      edtProjectName.Text := p.getProjectName;
      lblLastSavedDate.Caption := p.toString;
      lblProjectName.Caption := p.getProjectName;
      spnedtTempo.Value := p.getTempo;
      pID := p.getProjectID;
    end
  else
    begin
      btnLoadProject.Enabled := False;
      btnDeleteProject.Enabled := False;
      btnLoadProject.Color := clSilver;      {Disable components if no projects}
      btnDeleteProject.Color := clSilver;
      btnLoadProject.Font.Color := clGrayText;
      btnDeleteProject.Font.Color := clGrayText;
      lblLastSavedDate.Visible := False;
      btnSaveName.Enabled := False;
      edtProjectName.Enabled := False;
      spnedtTempo.Enabled := False;
      liProjects.Enabled := False;
      lblProjectName.Caption := '';
    end;
    
end;

end.
