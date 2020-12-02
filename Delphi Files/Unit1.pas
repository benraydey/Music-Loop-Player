unit Unit1;

interface

uses
  Windows, mmSystem, Messages, Math, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, jpeg, Buttons, Start, ADODB, DB, uButtons, uSamples, uButtonImage,
  WaveUtils, WaveStorage, WaveIO, WaveOut,
  WavePlayers, WaveRedirector, WaveTimer, Spin, AppEvnts;

type
  TMetronome = class(TThread)
  protected
    procedure Execute; override;
  end;

type
  TfrmSampleLaunchPad = class(TForm)
    pnlHeader: TPanel;
    sceneDesc1: TEdit;
    sceneDesc2: TEdit;
    sceneDesc3: TEdit;
    sceneDesc4: TEdit;
    sceneDesc5: TEdit;
    sceneDesc6: TEdit;
    sceneDesc7: TEdit;
    sceneDesc8: TEdit;
    pnlMetronome: TPanel;
    audio1: TStockAudioPlayer;
    waveStorage1: TWaveCollection;
    timer1: TMultimediaTimer;
    audio2: TStockAudioPlayer;
    audio3: TStockAudioPlayer;
    audio5: TStockAudioPlayer;
    audio6: TStockAudioPlayer;
    audio7: TStockAudioPlayer;
    audio8: TStockAudioPlayer;
    audio4: TStockAudioPlayer;
    waveStorage2: TWaveCollection;
    waveStorage3: TWaveCollection;
    waveStorage4: TWaveCollection;
    waveStorage5: TWaveCollection;
    waveStorage6: TWaveCollection;
    waveStorage7: TWaveCollection;
    waveStorage8: TWaveCollection;
    timer2: TMultimediaTimer;
    timer3: TMultimediaTimer;
    timer4: TMultimediaTimer;
    timer5: TMultimediaTimer;
    timer6: TMultimediaTimer;
    timer7: TMultimediaTimer;
    timer8: TMultimediaTimer;
    btnPlayMaster: TPanel;
    btnCloseProject: TPanel;
    btnSave: TPanel;
    btnPerformanceMode: TPanel;
    btnSampleLibrary: TPanel;
    lblTempo: TLabel;
    spnedtTempo: TSpinEdit;
    redHelp: TRichEdit;
    redNotePad: TRichEdit;
    pnlHideMiddle: TPanel;
    pnlHideTop: TPanel;
    pnlSampleLaunchArea: TPanel;
    pnlHideHelp: TPanel;
    btnHelpSwitch: TPanel;
    procedure ButtonsEvent(Sender : TObject);
    procedure LoadEvent(Sender : TObject);
    procedure ClearEvent(Sender : TObject);
    procedure timer1Timer(Sender: TObject);
    procedure btnPlayMasterClick(Sender: TObject);
    procedure timer2Timer(Sender: TObject);
    procedure timer3Timer(Sender: TObject);
    procedure timer4Timer(Sender: TObject);
    procedure timer5Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure timer6Timer(Sender: TObject);
    procedure timer7Timer(Sender: TObject);
    procedure timer8Timer(Sender: TObject);
    procedure btnSampleLibraryClick(Sender: TObject);
    procedure btnPerformanceClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SceneLaunch(Sender: TObject);
    procedure SceneDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3Click(Sender: TObject);
    procedure btnCloseProjectClick(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure spnedtTempoChange(Sender: TObject);
    procedure helpChange(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure redNotePadChange(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure PanelClick(Sender: TObject);
    procedure btnHelpSwitchClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSampleLaunchPad: TfrmSampleLaunchPad;
  buttons : array[1..64] of TButtonImage;
  labels : array[1..64] of TLabel;
  launchButtons : array[1..16] of TImage;
  b : TButtons;
  pID : integer;

  tempo : Real;

  playerBars,                              {How many bars before player must play again}
  playerCount,                             {Bar position of player - Reset to 1 everytime a sample changes}
  playerIndex : array[1..8] of integer;    {Index of wave file in wave storage}

  playing : Boolean;

  start, stop, freq : Int64;

  originalData : array[1..64] of TButtons;    {Used for undo function in loading samples}

  saveEnabled : Boolean;

implementation

Uses uSampleLibrary, uProjectsArray;

{$R *.dfm}



///////////////////////// METRONOME /////////////////////////////

{ TLooper }

procedure TMetronome.Execute;
var
  start, stop, freq : Int64;
  tick : Boolean;
  beatCount : Integer;
begin
  inherited;
  QueryPerformanceFrequency(freq);         { First counter starts before the loop. }
                                           { All others happen straight after      }
                                           { tick := true to minimise time loss    }

  frmSampleLaunchPad.pnlMetronome.Color := clLime;
  QueryPerformanceCounter(start);
  Sleep(50);
  frmSampleLaunchPad.pnlMetronome.Color := clSilver;
  
  for beatCount := 2 to 4 do
    begin

      //Metronome sequencer
      tick := false;

      While tick = false do
        begin
          QueryPerformanceCounter(Stop);
          If ((Stop - Start) / freq) >= (60 / Unit1.tempo) then
            tick := true;
        end;

      //Start timing immediately
      QueryPerformanceCounter(start);

      frmSampleLaunchPad.pnlMetronome.Color := clYellow;
      Sleep(50);
      frmSampleLaunchPad.pnlMetronome.Color := clSilver;


      sleep(0);
    end;

end;

////////////////////////////////////////////////////////////






///////////////////////// Button Click //////////////////////

{Labels and ButtonImages share the same OnClick event}

procedure TfrmSampleLaunchPad.ButtonsEvent(Sender : TObject);
var
  tag,
  channel, index : integer;
  b : TButtons;
  active : Boolean;
begin


  //Identify whether sender is ButtonImage or Label
  //Identify whether button index has assigned data

  active := false;

  If Sender.ClassName = 'TButtonImage' then
    begin
      b := (Sender AS TButtonImage).data;
      If b.getID <> 0 then
        begin
          active := true;
          tag := (Sender AS TButtonImage).Tag;
        end;
    end
  else
    begin
      If (Sender AS TLabel).Caption <> '' then
        begin
          active := true;
          tag := (Sender AS TLabel).Tag;
        end;
    end;

  If active then
    begin
      b := buttons[tag].data;
      channel := tag - ( ((tag - 1) DIV 8) * 8);      {Identify the column}
      index := 1 + (tag - 1) DIV 8;                   {Identify the row}

      //Change sample player variables
      //Requirement: Master player is playing AND the Sender has assigned data

      If playing AND active then
        begin

          If playerIndex[channel] = index then
            begin
              buttons[(channel + ((playerIndex[channel] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlue.jpg');
              playerIndex[channel] := 0;
              playerBars[channel] := 1;
              playerCount[channel] := 1;
            end
          else
            begin
              if playerIndex[channel] > 0 then
                buttons[(channel + ((playerIndex[channel] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlue.jpg');
              playerIndex[channel] := index;
              playerBars[channel] := b.getBars;
              playerCount[channel] := 1;
              buttons[(channel + ((playerIndex[channel] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreenInv.jpg');
            end;

        end;
    end;


end;



procedure TfrmSampleLaunchPad.LoadEvent(Sender : TObject);
var
  SelectedSample : TSamples;
  b,
  oldData : TButtons;
  index,
  channel,
  row : integer;
begin
  //Identify whether sender is ButtonImage or Label
  //Identify which button/label has been clicked

  If Sender.ClassName = 'TLabel' then   {Sender is a Lable}
    begin
      index := (Sender AS TLabel).Tag;
    end
  else                                {Sender is a ButtonImae}
    begin
      index := (Sender AS TButtonImage).Tag;
    end;


  channel := index - ( ((index - 1) DIV 8) * 8);    {Identify column of button}
  row := 1 + (index - 1) DIV 8;                     {Identify row of button}

  //Fetch Sample Data from Sample Library
  SelectedSample := uSampleLibrary.Selected;

  //Create button data object
  b := TButtons.Create(SelectedSample.getSampleID, SelectedSample.getBars, SelectedSample.getSampleName, SelectedSample.getFileName);

  oldData := buttons[index].data;


  If b.getID <> oldData.getID then       {Data has not yet been loaded to selected ButtonImage}
    begin

      //Change button data of Sender
      originalData[buttons[index].Tag] := buttons[index].data;  {Save original data in case of undo}
      buttons[index].data := b;

      //Change Graphics and Label Caption
      buttons[index].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadPink.jpg');
      labels[index].Caption := b.getName;

      //Update save button to indicate that changes have been made
      saveEnabled := True;
      btnSave.Font.Color := clHotLight;

      //Change Hint

      buttons[index].Hint := 'LOAD MODE#Click to undo.#Press Load to deactivate LOAD MODE#';
      labels[index].Hint := 'LOAD MODE#Click to undo.#Press Load to deactivate LOAD MODE#';

      //Load newly selected sample file to WaveCollections component
      (findComponent('waveStorage' + IntToStr(channel)) AS TWaveCollection).Waves[row].Wave.LoadFromFile(application.GetNamePath + 'Resources/Sounds/Loops/' + b.getFileName);

    end
  else         {Data has already been loaded and action is being undone}
    begin
      //Change button data to original
      buttons[index].data := originalData[buttons[index].tag];

      //Change Graphics and Label Caption
      labels[index].Caption := originalData[buttons[index].tag].getName;

      //Change Hint

      buttons[index].Hint := 'LOAD MODE#Click to load sample.#Press Load to deactivate LOAD MODE#';
      labels[index].Hint := 'LOAD MODE#Click to load sample.#Press Load to deactivate LOAD MODE#';

      If originalData[buttons[index].tag].getID <> 0 then    {Button has assigned data}
        begin
          buttons[index].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlueInv.jpg');
          (findComponent('waveStorage' + IntToStr(channel)) AS TWaveCollection).Waves[row].Wave.LoadFromFile(application.GetNamePath + 'Resources/Sounds/Loops/' + originalData[buttons[index].tag].getFileName);
        end
      else        {Button has no assigned data}
        begin
          buttons[index].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreyInv.jpg');
        end;
    end;



end;

procedure TfrmSampleLaunchPad.ClearEvent(Sender : TObject);
var
  index : integer;
  b : TButtons;
begin

  //Identify whether sender is ButtonImage or Label
  //Identify which button/label has been clicked

  If Sender.ClassName = 'TLabel' then        {Sender is a Label}
    begin
      index := (Sender AS TLabel).Tag;
    end
  else                                       {Sender is a ButtonImage}
    begin
      index := (Sender AS TButtonImage).Tag;
    end;

  b := buttons[index].data;



  if b.getID <> 0 then     {button has not yet been cleared}
    begin
      originalData[index] := b;            {save data in case of undo}
      b := TButtons.Create(0,0, '', '');
      buttons[index].data := b;            {load default data}

      //Change Graphics and Label Caption
      labels[index].Caption := '';
      buttons[index].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadPink.jpg');

      //Update save button to indicate that changes have been made
      saveEnabled := True;
      btnSave.Font.Color := clHotLight;

      //Change Hint

      buttons[index].Hint := 'CLEAR MODE#Click to undo.#Press Clear a Sample to deactivate CLEAR MODE#';
      labels[index].Hint := 'CLEAR MODE#Click to undo.#Press Clear a Sample to deactivate CLEAR MODE#';

    end
  else                    {button has already been cleared - action is being undone}
    begin
      buttons[index].data := originalData[index];

      //Change Graphics and Label Caption
      labels[index].Caption := originalData[index].getName;
      buttons[index].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlueInv.jpg');

      //Change Hint

      buttons[index].Hint := 'CLEAR MODE#Click to clear sample.#Press Clear a Sample to deactivate CLEAR MODE#';
      labels[index].Hint := 'CLEAR MODE#Click to clear sample.#Press Clear a Sample to deactivate CLEAR MODE#';

    end;


end;


////////////////////////////////////////////////////////////////



////////////////////// TIME KEEPERS //////////////////////

procedure TfrmSampleLaunchPad.timer1Timer(Sender: TObject);
begin

timer1.Interval := Trunc(240000 / tempo);

  //Play Sample

    If playerCount[1] = 1 then
      begin
        frmSampleLaunchPad.audio1.Stop;
        frmSampleLaunchPad.audio1.WaitForStop;
        sleep(0);
        frmSampleLaunchPad.audio1.PlayStock(playerIndex[1]);
        timer1.Interval := Trunc(240000 / tempo) - 6;
      end;

    If playerIndex[1] > 0 then
      buttons[(1 + ((playerIndex[1] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreen.jpg');

  //Change bar counter if necessary


    If playerCount[1] = playerBars[1] then
        begin
          playerCount[1] := 1;
        end
      else
        begin
          inc(playerCount[1]);
        end;

end;

procedure TfrmSampleLaunchPad.timer2Timer(Sender: TObject);
begin

  with TMetronome.Create(False) do           {Create seperate thread for metronome light}
    FreeOnTerminate := True;

  //Play Sample

    timer2.Interval := Trunc(240000 / tempo);

    If playerCount[2] = 1 then
      begin
        frmSampleLaunchPad.audio2.Stop;
        frmSampleLaunchPad.audio2.WaitForStop;
        frmSampleLaunchPad.audio2.PlayStock(playerIndex[2]);
        timer2.Interval := Trunc(240000 / tempo) - 6;
      end;

    If playerIndex[2] > 0 then
      buttons[(2 + ((playerIndex[2] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreen.jpg');

  //Change bar counter if necessary


    If playerCount[2] = playerBars[2] then
        begin
          playerCount[2] := 1;
        end
      else
        begin
          inc(playerCount[2]);
        end;

end;

procedure TfrmSampleLaunchPad.timer3Timer(Sender: TObject);
begin
  //Play Sample

  timer3.Interval := Trunc(240000 / tempo) ;

    If playerCount[3] = 1 then
      begin
        frmSampleLaunchPad.audio3.Stop;
        frmSampleLaunchPad.audio3.WaitForStop;
        frmSampleLaunchPad.audio3.PlayStock(playerIndex[3]);
        timer3.Interval := Trunc(240000 / tempo) - 6;
      end;

    If playerIndex[3] > 0 then
      buttons[(3 + ((playerIndex[3] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreen.jpg');

  //Change bar counter if necessary


    If playerCount[3] = playerBars[3] then
        begin
          playerCount[3] := 1;
        end
      else
        begin
          inc(playerCount[3]);
        end;


end;

procedure TfrmSampleLaunchPad.timer4Timer(Sender: TObject);
begin
  //Play Sample

  timer4.Interval := Trunc(240000 / tempo);

    If playerCount[4] = 1 then
      begin
        frmSampleLaunchPad.audio4.Stop;
        frmSampleLaunchPad.audio4.WaitForStop;
        frmSampleLaunchPad.audio4.PlayStock(playerIndex[4]);
        timer4.Interval := Trunc(240000 / tempo) - 6;
      end;

    If playerIndex[4] > 0 then
      buttons[(4 + ((playerIndex[4] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreen.jpg');

  //Change bar counter if necessary


    If playerCount[4] = playerBars[4] then
        begin
          playerCount[4] := 1;
        end
      else
        begin
          inc(playerCount[4]);
        end;


end;

procedure TfrmSampleLaunchPad.timer5Timer(Sender: TObject);
begin
  //Play Sample

  timer5.Interval := Trunc(240000 / tempo);

    If playerCount[5] = 1 then
      begin
        frmSampleLaunchPad.audio5.Stop;
        frmSampleLaunchPad.audio5.WaitForStop;
        frmSampleLaunchPad.audio5.PlayStock(playerIndex[5]);
        timer5.Interval := Trunc(240000 / tempo) - 6;
      end;

    If playerIndex[5] > 0 then
      buttons[(5 + ((playerIndex[5] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreen.jpg');

  //Change bar counter if necessary


    If playerCount[5] = playerBars[5] then
        begin
          playerCount[5] := 1;
        end
      else
        begin
          inc(playerCount[5]);
        end;


end;

procedure TfrmSampleLaunchPad.timer6Timer(Sender: TObject);
begin
  //Play Sample

  timer6.Interval := Trunc(240000 / tempo);

    If playerCount[6] = 1 then
      begin
        frmSampleLaunchPad.audio6.Stop;
        frmSampleLaunchPad.audio6.WaitForStop;
        frmSampleLaunchPad.audio6.PlayStock(playerIndex[6]);
        timer6.Interval := Trunc(240000 / tempo) - 6;
      end;

    If playerIndex[6] > 0 then
      buttons[(6 + ((playerIndex[6] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreen.jpg');

  //Change bar counter if necessary


    If playerCount[6] = playerBars[6] then
        begin
          playerCount[6] := 1;
        end
      else
        begin
          inc(playerCount[6]);
        end;

end;

procedure TfrmSampleLaunchPad.timer7Timer(Sender: TObject);
begin
  //Play Sample

  timer7.Interval := Trunc(240000 / tempo);

    If playerCount[7] = 1 then
      begin
        frmSampleLaunchPad.audio7.Stop;
        frmSampleLaunchPad.audio7.WaitForStop;
        frmSampleLaunchPad.audio7.PlayStock(playerIndex[7]);
        timer7.Interval := Trunc(240000 / tempo) - 6;
      end;

    If playerIndex[7] > 0 then
      buttons[(7 + ((playerIndex[7] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreen.jpg');

  //Change bar counter if necessary


    If playerCount[7] = playerBars[7] then
        begin
          playerCount[7] := 1;
        end
      else
        begin
          inc(playerCount[7]);
        end;

end;

procedure TfrmSampleLaunchPad.timer8Timer(Sender: TObject);
begin
  //Play Sample

  timer8.Interval := Trunc(240000 / tempo);

    If playerCount[8] = 1 then
      begin
        frmSampleLaunchPad.audio8.Stop;
        frmSampleLaunchPad.audio8.WaitForStop;
        frmSampleLaunchPad.audio8.PlayStock(playerIndex[8]);
        timer8.Interval := Trunc(240000 / tempo) - 6;
      end;

    If playerIndex[8] > 0 then
      buttons[(8 + ((playerIndex[8] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreen.jpg');

  //Change bar counter if necessary


    If playerCount[8] = playerBars[8] then
        begin
          playerCount[8] := 1;
        end
      else
        begin
          inc(playerCount[8]);
        end;

end;



////////////////////////////////////////////////////////////////




procedure TfrmSampleLaunchPad.btnPlayMasterClick(Sender: TObject);
var
  i : integer;
begin
  If playing = true then
    begin
      playing := false;

      timer1.Enabled := False;
      timer2.Enabled := False;
      timer3.Enabled := False;
      timer4.Enabled := False;        {Stop Timers}
      timer5.Enabled := False;
      timer6.Enabled := False;
      timer7.Enabled := False;
      timer8.Enabled := False;

      audio1.Stop;
      audio2.Stop;
      audio3.Stop;
      audio4.Stop;                   {Stop Wave Players}
      audio5.Stop;
      audio6.Stop;
      audio7.Stop;
      audio8.Stop;

                                     {Reset pictures of ButtonImages}
      for i := 1 to 64 do
        begin
          b := buttons[i].data;
          if b.getID > 0 then
            begin
              buttons[i].Picture.LoadFromFile(application.getNamePath + 'Resources/Images/PadBlue.jpg');
            end
          else
            begin
              buttons[i].Picture.LoadFromFile(application.getNamePath + 'Resources/Images/PadGrey.jpg');
            end;
        end;

      for i := 1 to 16 do             {Disable sample launch buttons}
        begin
          launchButtons[i].Enabled := False;
        end;

    end
  else
    begin
      playing := true;

      for i := 1 to 16 do
        begin
          launchButtons[i].Enabled := True;
        end;

      for i := 1 to 8 do
        begin
          playerCount[i] := 1;      {Reset Configuration}
          playerBars[i] := 1;      { of sample players }
          playerIndex[i] := 0;
        end;

      for i := 1 to 8 do
        begin
          (FindComponent('timer' + intToStr(i)) AS TMultimediaTimer).Enabled := true;
          (FindComponent('audio' + intToStr(i)) AS TStockAudioPlayer).PlayStock(0);
        end;

      with TMetronome.Create(False) do           {Create seperate thread for metronome light}
      FreeOnTerminate := True;

     end;
end;




procedure TfrmSampleLaunchPad.FormShow(Sender: TObject);
var
  SQLq : String;
  queryOne, queryTwo, queryProjects : TADOQuery;
  i, id, index, channel : integer;
  conn : TADOConnection;
  projectsDB : TProjectsArray;
begin
  frmSampleLaunchPad.Visible := True;
  application.ProcessMessages;
  //Fetch Project ID from Start Menu Unit
  id := frmStartMenu.pID;
  pID := id;

  //Database Connections
  conn := TADOConnection.Create(NIL);
  conn.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;Extended Properties="DBQ=' + 'db.mdb' + ';Driver={Driver do Microsoft Access (*.mdb)};DriverId=25;FIL=MS Access;FILEDSN=C:\Program Files\Common Files\ODBC\Data Sources\Test.dsn;MaxBufferSize=2048;MaxScanRows=8;PageTimeout=5;SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;"';


  //Query the database - Buttons
  SQLq := 'SELECT SampleID FROM tblButtons WHERE ProjectID = ' + IntToStr(id) + ' ORDER BY ButtonID;';

  queryOne := TADOQuery.Create(NIL);
  queryOne.Connection := conn;
  queryOne.SQL.Add(sqlQ);
  queryOne.Active := true;


  //Query the database - Projects
  SQLq := 'SELECT * FROM tblProjects WHERE ProjectID = ' + IntToStr(id);

  queryProjects := TADOQuery.Create(NIL);
  queryProjects.Connection := conn;
  queryProjects.SQL.Add(sqlQ);
  queryProjects.Active := true;

  //Configure interface and variables for loaded project
  frmSampleLaunchPad.Caption := QueryProjects.FieldValues['ProjectName'];
  tempo := QueryProjects.FieldValues['Tempo'];

  //Dynamically create 64 buttons and labels on Sample Launch Pad

  For i := 1 to 64 do
    begin
      buttons[i] := TButtonImage.Create(self);
      buttons[i].Parent := pnlSampleLaunchArea;
      //Query the database to get Sample data
      //Req: Button has associated sample data (SampleID <> 0)

      If queryOne.FieldValues['SampleID'] <> 0 then
        begin
          SQLq := 'SELECT * FROM tblSamples WHERE SampleID = ' + IntToStr(queryOne.FieldValues['SampleID']);

          queryTwo := TADOQuery.Create(NIL);
          queryTwo.Connection := conn;          {Query tblSamples to extract data}
          queryTwo.SQL.Add(sqlQ);               {    for that specific sample    }
          queryTwo.Active := true;

          //Create a button data object
          b := TButtons.Create(queryTwo.FieldValues['SampleID'], queryTwo.FieldValues['Bars'], queryTwo.FieldValues['SampleName'], queryTwo.FieldValues['FileName']);
          queryTwo.Close;

          //Store wave file in WaveCollection component
          index := 1 + (i - 1) DIV 8;
          channel := i - ( ((i - 1) DIV 8) * 8);
          (FindComponent('waveStorage' + IntToStr(channel)) AS TWaveCollection).Waves[ index ].Wave.LoadFromFile(application.GetNamePath + 'Resources/Sounds/Loops/' + b.getFileName);
          (FindComponent('waveStorage' + IntToStr(channel)) AS TWaveCollection).Waves[ index ].Tag := b.getBars;
        end
      else
        begin
          b := TButtons.Create(0, 0, '', '');   {button gets defualt data if no}
        end;                                    {      assigned data           }
          buttons[i].data := b;



      //Create a corresponding label
          labels[i] := TLabel.Create(Self);


      //Configure TButtonIamge and corresponging label    
      If b.getName <> '' then
        begin
          labels[i].Caption := b.getName;

          buttons[i].Picture.LoadFromFile(application.getNamePath + 'Resources/Images/PadBlue.jpg');
        end
      else
        begin
          labels[i].Caption := '';

          buttons[i].Picture.LoadFromFile(application.getNamePath + 'Resources/Images/PadGrey.jpg');
        end;

      buttons[i].Height := 60;          {button dimensions}
      buttons[i].Width := 60;

      buttons[i].Left :=  ((i - ( ((i-1) DIV 8) * 8) - 1 ) ) * 72;           {button position}
      buttons[i].Top :=  ( (i - 1) DIV 8 ) * 72;

      //Create a corresponding label
      labels[i].WordWrap := True;
      labels[i].Width := 45;                {adjust label parametres}
      labels[i].Height := 45;
      labels[i].Left := 8 + ( (i - ( ((i-1) DIV 8) * 8) - 1 )  * 72);
      labels[i].Top := 8 + ( ( (i - 1) DIV 8 ) * 72);
      labels[i].Alignment := taCenter;
      labels[i].Transparent := True;
      labels[i].Font.Color := clWhite;

      buttons[i].Visible := True;
      labels[i].Visible := True;                {Show and bring to front}
      labels[i].BringToFront;

      //Assign Tag, and OnMouseMove and OnClick Event to label and ButtonImage
      buttons[i].Tag := i;
      buttons[i].OnClick := ButtonsEvent;
      buttons[i].OnMouseMove := helpChange;
      buttons[i].Hint := 'Sample Launch Buttons#Play assigned samples in a loop.#Enable Performance Mode and press Master Play to enable:#l | 4';
      buttons[i].Parent := pnlSampleLaunchArea;

      labels[i].Tag := i;
      labels[i].OnClick := ButtonsEvent;
      labels[i].OnMouseMove := helpChange;
      labels[i].Hint := 'Sample Launch Buttons#Play assigned samples in a loop.#Enable Performance Mode and press Master Play to enable:#l | 4';
      labels[i].Parent := pnlSampleLaunchArea;

      application.ProcessMessages;
      queryOne.Next;
    end;

  queryOne.Close;

  //Assign silent wave files

  for i := 1 to 8 do
    begin
      (FindComponent('waveStorage' + IntToStr(i)) AS TWaveCollection).Waves[ 0 ].Wave.LoadFromFile(application.GetNamePath + 'Resources/Sounds/Misc/Silence.WAV');
    end;

  //Dynamically create 8 scene launch buttons and 8 scene stop buttons

  for i := 1 to 8 do
    begin
      launchButtons[i] := TImage.Create(Self);
      launchButtons[i].Parent := frmSampleLaunchPad;
      launchButtons[i].Height := 25;
      launchButtons[i].Width := 41;
      launchButtons[i].Left := 152;
      launchButtons[i].Top := 72 + ( (i - 1) * 72);
      launchButtons[i].Tag := i;
      launchButtons[i].OnClick := SceneLaunch;
      launchButtons[i].OnMouseDown := SceneDown;
      launchButtons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/Play.jpg');
      launchButtons[i].Visible := True;
      launchButtons[i].Enabled := True;
      launchButtons[i].OnMouseMove := helpChange;
      launchButtons[i].Hint := 'Scene Launch Button#Triggers all Launch Buttons in the scene (row of 8 buttons)#Enable Performance Mode and press Master Play to enable:#l | 4';
    end;

  for i := 9 to 16 do
    begin
      launchButtons[i] := TImage.Create(Self);
      launchButtons[i].Parent := frmSampleLaunchPad;
      launchButtons[i].Height := 25;
      launchButtons[i].Width := 41;
      launchButtons[i].Left := 192;
      launchButtons[i].Top := 72 + ( (i - 9) * 72);
      launchButtons[i].Tag := i;
      launchButtons[i].OnClick := SceneLaunch;
      launchButtons[i].OnMouseDown := SceneDown;
      launchButtons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/Stop.jpg');
      launchButtons[i].Visible := True;
      launchButtons[i].Enabled := True;
      launchButtons[i].OnMouseMove := helpChange;
      launchButtons[i].Hint := 'Scene Stop Button#Stops all Launch Buttons in the scene (row of 8 buttons)#Enable Performance Mode and press Master Play to enable:#l | 4';
    end;

    spnedtTempo.Value := StrToInt(FloatToStr(tempo));

    {change save panel graphics to "saved" since above code will enable save panel}
    saveEnabled := False;
    btnSave.Font.Color := $007F7F7F;

    {fill Note Pad}

    If FileExists(GetCurrentDir + '\Resources\Note Files\' + IntToStr(pID) + '.txt') then
      begin
        redNotePad.Lines.LoadFromFile(GetCurrentDir + '\Resources\Note Files\' + IntToStr(pID) + '.txt');
      end
    else
      begin
        redNotePad.Lines.Add('Notepad...');
      end;

    projectsDB := TProjectsArray.Create('db.mdb');

    for i := 1 to 8 do
      begin
        (FindComponent('sceneDesc' + IntToStr(i)) AS TEdit).Text := ProjectsDB.getSceneDescription(pID, i);
      end;

    {save configuration}
      saveEnabled := False;
      btnSave.Font.Color := clGray;

    {help configuration}
    with btnHelpSwitch do
      begin
        tag := 0;
        pnlHideHelp.Visible := False;
        Font.Color := clCream;
      end;

end;



procedure TfrmSampleLaunchPad.btnSampleLibraryClick(Sender: TObject);
begin
  If frmSampleLibrary.Visible = true then
    begin
      frmSampleLibrary.BringToFront;
    end
  else
    begin
      frmSampleLibrary.Visible := True;
    end;

end;

procedure TfrmSampleLaunchPad.btnPerformanceClick(Sender: TObject);
var i : integer;
begin

  If playing then
    begin
      If tag = 0 then      {Performance mode is off}
        begin
          if frmSampleLibrary.Visible = true then   {Check if Sample Library is open before activating peformance mode}
            begin
              tag := 1;
            end
          else
            begin
              tag := 2;
            end;
          btnPlayMaster.Enabled := True;
          frmSampleLibrary.Visible := False;
          for i := 1 to 16 do             {Enable sample launch buttons}
            begin
              launchButtons[i].Enabled := True;
            end;
        end
      else if tag = 1 then        {Performance mode is on and Sample Library needs to be opened}
        begin
          tag := 0;
          frmSampleLibrary.Visible := True;
          btnPlayMaster.Enabled := False;
          for i := 1 to 16 do             {Disable sample launch buttons}
            begin
              launchButtons[i].Enabled := False;
            end;
        end
      else                        {Performance mode is on}
        begin
          tag := 0;
          btnPlayMaster.Enabled := False;
          for i := 1 to 16 do             {Disable sample launch buttons}
            begin
              launchButtons[i].Enabled := False;
            end;
        end;
    end;
end;

procedure TfrmSampleLaunchPad.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmSampleLibrary.Visible := False;
  frmStartMenu.Visible := True;
end;







//////////////////////// Scene Launch ////////////////////////


procedure TfrmSampleLaunchPad.SceneLaunch(Sender: TObject);
var
  i : integer;
  b : TButtons;
  tag : integer;
begin
  If playing then     {check if playing and performance mode is active}
    begin
      tag := (Sender AS TImage).Tag;

      if tag < 9 then     {Button is play button}
        begin

          for i := 1 to 8 do
            begin

              if playerIndex[i] > 0 then
                begin
                  buttons[(i + ((playerIndex[i] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlue.jpg');
                end;

              b := buttons[( (tag - 1) * 8 ) + i].data;
              if b.getID <> 0 then
                begin
                  playerIndex[i] := tag;
                  playerBars[i] := b.getBars;
                  playerCount[i] := 1;
                  buttons[(i + ((playerIndex[i] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreenInv.jpg');
                end
              else
                begin
                  playerIndex[i] := 0;
                  playerBars[i] := 1;
                  playerCount[i] := 1;
                end;
            end;

        end
      else             {Button is stop button}
        begin

        for i := 1 to 8 do
          begin

          if playerIndex[i] = tag - 8 then
            begin
              buttons[(i + ((playerIndex[i] - 1) * 8) )].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlue.jpg');
              playerIndex[i] := 0;
              playerBars[i] := 1;
              playerCount[i] := 1;
            end;

          end;


        end;
    end;
end;




//////////////////////////////////////////////////////////////


procedure TfrmSampleLaunchPad.SceneDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tag : integer;
begin
  If playing then {check if playing is active}
    begin
      tag := (Sender AS TImage).Tag;

      if tag < 9 then          {Play Button}
        begin
          launchButtons[tag].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PlayClick.jpg');
          application.ProcessMessages;
          Sleep(100);
          launchButtons[tag].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/Play.jpg');
        end
      else                     {Stop Button}
        begin
          launchButtons[tag].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/StopClick.jpeg');
          application.ProcessMessages;
          Sleep(100);
          launchButtons[tag].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/Stop.jpg');
        end;
    end;
end;

procedure TfrmSampleLaunchPad.Panel3Click(Sender: TObject);
var
  i : integer;
begin
  If (btnPerformanceMode.Tag = 1) OR (btnPerformanceMode.Tag = 2)  then     {check if performance mode is active}
    begin
      If playing = true then
        begin
          btnPerformanceMode.Visible := True;
          btnPlayMaster.Color := $00AAAAAA;

          playing := false;

          timer1.Enabled := False;
          timer2.Enabled := False;
          timer3.Enabled := False;
          timer4.Enabled := False;        {Stop Timers}
          timer5.Enabled := False;
          timer6.Enabled := False;
          timer7.Enabled := False;
          timer8.Enabled := False;

          audio1.Stop;
          audio2.Stop;
          audio3.Stop;
          audio4.Stop;                   {Stop Wave Players}
          audio5.Stop;
          audio6.Stop;
          audio7.Stop;
          audio8.Stop;

                                         {Reset pictures of ButtonImages}
          for i := 1 to 64 do
            begin
              b := buttons[i].data;
              if b.getID > 0 then
                begin
                  buttons[i].Picture.LoadFromFile(application.getNamePath + 'Resources/Images/PadBlue.jpg');
                end
              else
                begin
                  buttons[i].Picture.LoadFromFile(application.getNamePath + 'Resources/Images/PadGrey.jpg');
                end;
            end;

          for i := 1 to 16 do             {Disable sample launch buttons}
            begin
              launchButtons[i].Enabled := False;
            end;

        end
      else
        begin
          playing := true;
          btnPerformanceMode.Visible := False;
          btnPlayMaster.Color := clMoneyGreen;     {play button graphics}


          for i := 1 to 16 do
            begin
              launchButtons[i].Enabled := True;
            end;

          for i := 1 to 8 do
            begin
              playerCount[i] := 1;      {Reset Configuration}
              playerBars[i] := 1;      { of sample players }
              playerIndex[i] := 0;
            end;

          for i := 1 to 8 do
            begin
              (FindComponent('timer' + intToStr(i)) AS TMultimediaTimer).Enabled := true;
              (FindComponent('audio' + intToStr(i)) AS TStockAudioPlayer).PlayStock(0);
            end;

          with TMetronome.Create(False) do           {Create seperate thread for metronome light}
          FreeOnTerminate := True;

         end;
    end;
end;

procedure TfrmSampleLaunchPad.btnCloseProjectClick(Sender: TObject);
begin
  frmSampleLaunchPad.Close;
end;

procedure TfrmSampleLaunchPad.Panel6Click(Sender: TObject);
var
  i : integer;
begin
  If btnPerformanceMode.tag = 0 then      {Performance mode is off}
    begin

      //Change graphic colour
      btnPerformanceMode.Font.Color := clYellow;
      btnPerformanceMode.Color := clSkyBlue;

      if frmSampleLibrary.Visible = true then   {Check if Sample Library is open before activating peformance mode}
        begin
          btnPerformanceMode.tag := 1;
        end
      else
        begin
           btnPerformanceMode.tag := 2;
        end;
      btnPlayMaster.Font.Color := clGreen;
      frmSampleLibrary.Visible := False;
      btnCloseProject.Visible := False;
      btnSave.Visible := False;
      btnSampleLibrary.Visible := False;
      lblTempo.Visible := False;
      spnedtTempo.Visible := False;
      redHelp.Visible := False;
      btnHelpSwitch.Visible := False;
      pnlHideHelp.Visible := False;

      {notepad and scene descriptions - change to read only}

      for i := 1 to 8 do
        begin
          (FindComponent('sceneDesc' + IntToStr(i)) AS TEdit).ReadOnly := True;
        end;

      redNotepad.ReadOnly := True;

    end
  else if btnPerformanceMode.tag = 1 then        {Performance mode is on and Sample Library needs to be opened}
    begin
      //Change graphic colour
      btnPerformanceMode.Font.Color := clBlack;
      btnPerformanceMode.Color := clSilver;
      btnPerformanceMode.tag := 0;
      frmSampleLibrary.Visible := True;
      btnPlayMaster.Font.Color := $007F7F7F;
      btnCloseProject.Visible := True;
      btnSave.Visible := True;
      btnSampleLibrary.Visible := True;
      lblTempo.Visible := True;
      spnedtTempo.Visible := True;
      If btnHelpSwitch.Font.Color = clRed then
        begin
          pnlHideHelp.Visible := True;
        end;
      redHelp.Visible := True;
      btnHelpSwitch.Visible := True;


      {notepad and scene descriptions - change to read and write}

      for i := 1 to 8 do
        begin
          (FindComponent('sceneDesc' + IntToStr(i)) AS TEdit).ReadOnly := False;
        end;

      redNotepad.ReadOnly := False;

    end
  else                        {Performance mode is on}
    begin
    tag := 0;
      //Change panel graphic
      btnPlayMaster.Font.Color := $007F7F7F;
      btnCloseProject.Visible := True;
      btnSave.Visible := True;
      btnSampleLibrary.Visible := True;
      lblTempo.Visible := True;
      spnedtTempo.Visible := True;
      redHelp.Visible := True;

      {notepad and scene descriptions - change to read and write}

      for i := 1 to 8 do
        begin
          (FindComponent('sceneDesc' + IntToStr(i)) AS TEdit).ReadOnly := False;
        end;

      redNotepad.ReadOnly := False;

    end;

end;

procedure TfrmSampleLaunchPad.btnSaveClick(Sender: TObject);
var
  save : TProjectsArray;
  i : integer;
begin
  If saveEnabled = true then
    begin
      save := TProjectsArray.Create('db.mdb');
      save.saveProject(pID);
      save.saveTempo(StrToInt(FloatToStr(tempo)), pID);
    end;

  {save text files}

  {note pad}
    redNotePad.Lines.SaveToFile(GetCurrentDir + '\Resources\Note Files\' + IntToStr(pID) + '.txt');
  {scene descriptions}
    for i := 1 to 8 do
      begin
        save.saveSceneDescriptions(pID, i,  (FindComponent('sceneDesc' + IntToStr(i)) AS TEdit).Text ) ;
      end;


  end;

procedure TfrmSampleLaunchPad.spnedtTempoChange(Sender: TObject);
begin
  //Update save button to indicate that changes have been made
      saveEnabled := True;
      btnSave.Font.Color := clHotLight;
      tempo := spnedtTempo.Value;
end;

procedure TfrmSampleLaunchPad.helpChange(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  helpString : string;
begin
  If Sender.ClassName = 'TPanel' then
    begin
      helpString := (Sender AS TPanel).Hint;
    end
  else
    if Sender.ClassName = 'TEdit' then
      begin
        helpString := (Sender AS TEdit).Hint;
      end
  else
    if Sender.ClassName = 'TRichEdit' then
      begin
        helpString := (Sender AS TRichEdit).Hint;
      end
  else
    if Sender.ClassName = 'TSpinEdit' then
      begin
        helpString := (Sender AS TSpinEdit).Hint;
      end
  else
    if Sender.ClassName = 'TfrmSampleLaunchPad' then
      begin
        helpString := (Sender AS TfrmSampleLaunchPad).Hint;
      end
  else
    if Sender.ClassName = 'TImage' then
      begin
        helpString := (Sender AS TImage).Hint;
      end
  else
    if Sender.ClassName = 'TButtonImage' then
      begin
        helpString := (Sender AS TButtonImage).Hint;
      end
  else
    if Sender.ClassName = 'TLabel' then
      begin
        helpString := (Sender AS TLabel).Hint;
      end;


  {output help to richedit}
  redHelp.Clear;

  redHelp.SelAttributes.Name := 'Arial';
  redHelp.SelAttributes.Color := clYellow;
  redHelp.SelAttributes.Charset := ANSI_CHARSET;
  redHelp.SelAttributes.Style := [fsBold];
  redHelp.SelAttributes.Size := 9;
  redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13 + #13);

  delete(helpString, 1, pos('#', helpString) );
  redHelp.SelAttributes.Name := 'Arial';
  redHelp.SelAttributes.Charset := ANSI_CHARSET;
  redHelp.SelAttributes.Style := [];
  redHelp.SelAttributes.Size := 9;
  redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13 + #13);

  delete(helpString, 1, pos('#', helpString) );
  redHelp.SelAttributes.Name := 'Arial';
  redHelp.SelAttributes.Charset := ANSI_CHARSET;
  redHelp.SelAttributes.Size := 8;
  redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13);

  delete(helpString, 1, pos('#', helpString) );
  If length(helpString) > 0 then
    begin
      redHelp.SelAttributes.Size := 14;
      redHelp.SelAttributes.Name := 'Webdings';
      redHelp.SelAttributes.Charset := SYMBOL_CHARSET;
      redHelp.Lines.Add(helpString);
    end;

end;

procedure TfrmSampleLaunchPad.redNotePadChange(Sender: TObject);
begin
//Update save button to indicate that changes have been made
  saveEnabled := True;
  btnSave.Font.Color := clHotLight;
end;

procedure TfrmSampleLaunchPad.FormClick(Sender: TObject);
begin
  pnlSampleLaunchArea.SetFocus;
end;

procedure TfrmSampleLaunchPad.PanelClick(Sender: TObject);
begin
  (Sender AS TPanel).SetFocus;
end;

procedure TfrmSampleLaunchPad.btnHelpSwitchClick(Sender: TObject);
begin
  If tag = 0 then
    begin
      tag := 1;
      pnlHideHelp.Visible := True;
      btnHelpSwitch.Font.Color := clRed;
    end
  else
    begin
      tag := 0;
      pnlHideHelp.Visible := False;
      btnhelpSwitch.Font.Color := clCream;
    end;
end;

end.
