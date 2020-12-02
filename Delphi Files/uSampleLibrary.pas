unit uSampleLibrary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, uSamplesArray, uSamples,  mmSystem,
  ExtCtrls, ALAudioOut, ALCommonPlayer, ALWavePlayer, ALCommonFilter,
  ALGenericFilter, uButtons, ComCtrls;

type
  TfrmSampleLibrary = class(TForm)
    liCat: TListBox;
    liSubCat: TListBox;
    liSamples: TListBox;
    lblSampleName: TLabel;
    lblInstrument: TLabel;
    playerPreview: TALWavePlayer;
    audioOutPreview: TALAudioOut;
    pnlSampleInfo: TPanel;
    btnPlaySample: TPanel;
    btnLoadSample: TPanel;
    btnFavourite: TPanel;
    pnlHeader: TPanel;
    btnClearSample: TPanel;
    btnAddSample: TPanel;
    tbListView: TTabSheet;
    tbTileView: TTabSheet;
    pgCtrlView: TPageControl;
    pnlHideTop: TPanel;
    pnlHideBottom: TPanel;
    pnlHide2: TPanel;
    pnlHide1: TPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure liCatClick(Sender: TObject);
    procedure liSubCatClick(Sender: TObject);
    procedure liSamplesClick(Sender: TObject);
    procedure btnFavClick(Sender: TObject);
    procedure btnPlaysSampleClick(Sender: TObject);
    procedure btnloaClick(Sender: TObject);
    procedure btnClearSampleClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure liCatDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure liSubCatDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure liSamplesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnPlaySampleClick(Sender: TObject);
    procedure btnLoadSampleClick(Sender: TObject);
    procedure btnFavouriteClick(Sender: TObject);
    procedure btnPlaySampleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnPlaySampleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnPlaySampleMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnFavouriteExit(Sender: TObject);
    procedure pnlSampleInfoMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Panel1Click(Sender: TObject);
    procedure btnLoadSampleMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnFavouriteMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAddSampleClick(Sender: TObject);
    procedure tagTileClick(Sender: TObject);
    procedure pgCtrlViewChange(Sender: TObject);
    procedure pgCtrlViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure PopulateLiSamples;
  procedure SelectFirstSample;
  procedure NewSample;
  procedure Reset;

var
  frmSampleLibrary: TfrmSampleLibrary;
  playFileName : String;
  sampleID,
  tagTilesCount : Integer;
  Selected : TSamples;
  SubCatList : TStringList;
  SamplesList : TStringList;
  arrTagTiles : array[1..33] of TPanel;
  tagCombination : TStringList;
  possibleTags : TStringList;

implementation

uses Unit1, DateUtils, uFrmAddSample;

{$R *.dfm}

procedure TfrmSampleLibrary.FormCreate(Sender: TObject);
var sampleDB : TSamplesArray;
  tagList,
  instrumentList,
  genreList,
  moodsList : TStringList;
  i, index : integer;
begin
  sampleDB := TSamplesArray.Create('db.mdb');

  liCat.Items := sampleDB.getCategories;
  liCat.ItemIndex := 0;

  {Dynamically create tag tile panels}

    {create a tag list}

    tagList := TStringList.Create;
    tagList.Add('Reset');

    {extract Genres list and add to tag list}
    genreList := sampleDB.getGenres;

    {add genres to tag list}
    for i := 1 to genreList.Count do
      begin
        tagList.Add(genreList.Strings[i - 1]);
      end;

    {extract intruments list}
    instrumentList := sampleDB.getInstruments(False);

    {add instruments to tag list}
    for i := 1 to instrumentList.Count do
      begin
        tagList.Add(instrumentList.Strings[i - 1]);
      end;

    {extract moods}
    moodsList := sampleDB.getMoods(True);

    {add moods to tag list}
    for i := 1 to moodsList.Count do
      begin
        tagList.Add(moodsList.Strings[i - 1]);
      end;

    {Create panels}

    {First panel is Reset}
    arrTagTiles[1] := TPanel.Create(Self);
    arrTagTiles[1].Caption :=tagList.Strings[0];
    arrTagTiles[1].Parent := tbTileView;
    arrTagTiles[1].Font.Name := 'Arial';
    arrTagTiles[1].Font.Size := 8;
    arrTagTiles[1].Height := 12;
    arrTagTiles[1].Width := 73;
    arrTagTiles[1].Color := clMedGray;
    arrTagTiles[1].Font.Color := clGray;
    arrTagTiles[1].Top :=  8;
    arrTagTiles[1].Left := 8;
    arrTagTiles[1].Font.Charset := ANSI_CHARSET;
    arrTagTiles[1].Font.Style := [];
    arrTagTiles[1].BevelOuter := bvNone;
    arrTagTiles[1].Tag := 0;
    arrTagTiles[1].OnClick := tagTileClick;

    tagTilesCount := tagList.Count;

    for i := 2 to tagTilesCount do
      begin
        arrTagTiles[i] := TPanel.Create(Self);
        arrTagTiles[i].Caption := tagList.Strings[ i - 1 ];
        arrTagTiles[i].Parent := tbTileView;
        arrTagTiles[i].Font.Name := 'Arial';
        arrTagTiles[i].Font.Size := 8;
        arrTagTiles[i].Height := 12;
        arrTagTiles[i].Width := 73;
        arrTagTiles[i].Color := clSkyBlue;
        arrTagTiles[i].Font.Color := clBtnText;
        arrTagTiles[i].Font.Charset := ANSI_CHARSET;
        arrTagTiles[i].Font.Style := [];
        arrTagTiles[i].BevelOuter := bvNone;
        arrTagTiles[i].Tag := 0;

        {arrangement formulae}
        arrTagTiles[i].Top :=  8 + ( (i - ( ((i-1) DIV 11) * 11) - 1 )  * 16);
        arrTagTiles[i].Left := 8 + ( ( (i - 1) DIV 11 ) * 88);

        arrTagTiles[i].OnClick := tagTileClick;
      end;

      tagCombination := TStringList.Create;

      possibleTags := sampleDB.possibleTags(tagCombination, false);

      possibleTags.Sort;
      for i := 2 to tagTilesCount do
      begin
        If possibleTags.Find(arrTagTiles[i].Caption, index) = false then
          begin
            arrTagTiles[i].Enabled := False;
            arrTagTiles[i].Color := clMedGray;
            arrTagTiles[i].Font.Color := clGray;
          end;
      end;

    {Fill Samples list box}
      liSamples.Items := sampleDB.getAllSamples;
      SamplesList := sampleDB.getAllSamples;
      liSamples.ItemIndex := 0;

    //Select first sample
    SelectFirstSample;

    liSamples.Font.Style := [];

end;

procedure TfrmSampleLibrary.liCatClick(Sender: TObject);
var
  sampleDB : TSamplesArray;
  pos : integer;
begin

  sampleDB := TSamplesArray.Create('db.mdb');

  //Refill list box for OnDrawItem to activate
  pos := liCat.ItemIndex;
  liCat.Items := sampleDB.getCategories;
  liCat.ItemIndex := pos;

  If liCat.Items.Strings[liCat.ItemIndex] = 'All' then
    begin
      liSamples.Items := sampleDB.getAllSamples;
      SamplesList := sampleDb.getAllSamples;
      liSamples.ItemIndex := 0;
      liSubCat.Clear;
    end;

  If liCat.Items.Strings[liCat.ItemIndex] = 'Favourites' then
    begin
      liSamples.Items := sampleDB.getFavourites;
      SamplesList := sampleDB.getFavourites;
      liSamples.ItemIndex := 0;
      liSubCat.Clear;

      If liSamples.Items.Count = 0 then
        begin
          btnPlaySample.Enabled := False;
          lblSampleName.Caption := '';
          lblInstrument.Caption := '';
          btnFavourite.Enabled := False;
        end;
    end;

  If liCat.Items.Strings[liCat.ItemIndex] = 'Genre' then
    begin
      liSubCat.Items := sampleDB.getGenres;
      SubCatList := sampleDB.getGenres;
    end;

  If liCat.Items.Strings[liCat.ItemIndex] = 'Instrument' then
    begin
      liSubCat.Items := sampleDB.getInstruments(False);
      SubCatList := sampleDB.getInstruments(False);
    end;

  If liCat.Items.Strings[liCat.ItemIndex] = 'Mood' then
    begin
      liSubCat.Items := sampleDB.getMoods(True);
      SubCatList := sampleDB.getMoods(True);
    end;

  //Select first sample

  SelectFirstSample;

end;

procedure TfrmSampleLibrary.liSubCatClick(Sender: TObject);
var
  sampleDB : TSamplesArray;
  s : TSamples;
  pos : integer;
begin

  sampleDB := TSamplesArray.Create('db.mdb');

  //Refill list box for OnDrawItem to activate
  pos := liSubCat.ItemIndex;
  liSubCat.Items := SubCatList;
  liSubCat.ItemIndex := pos;

  liSamples.Items := sampleDB.getSamplesWhere(liSubCat.Items.Strings[liSubCat.ItemIndex]);
  SamplesList := sampleDB.getSamplesWhere(liSubCat.Items.Strings[liSubCat.ItemIndex]);
  //SELECT FIRST SAMPLE
    SelectFirstSample;

end;

procedure TfrmSampleLibrary.liSamplesClick(Sender: TObject);
var
  pos : integer;
begin

  //Refill list box for OnDrawItem to activate
  pos := liSamples.ItemIndex;
  liSamples.Items := SamplesList;
  liSamples.ItemIndex := pos;

  Selected := liSamples.Items.Objects[liSamples.ItemIndex] as TSamples;

  lblSampleName.Caption := Selected.getSampleName;
  lblInstrument.Caption := Selected.getInstrument;
  lblInstrument.Caption := Selected.getInstrument + '  ' + FloatToStr(Selected.getTempo) + ' bpm';
  playFileName := Selected.getFileName;
  sampleID := Selected.getSampleID;


  //Favourites

  If Selected.getFavourite = 'True' then
    begin
      btnFavourite.Font.Color := clYellow;
    end;

  If Selected.getFavourite = 'False' then
    begin
      btnFavourite.Font.Color := clGray;
    end;


  //Load selected sample to sample player
  //Req: new sample is not already playing
  If playerPreview.FileName <> application.GetNamePath + 'Resources/Sounds/Loops/' + playFileName then
    begin
      playerPreview.Stop;
      playerPreview.Paused := True;
      playerPreview.FileName := application.GetNamePath + 'Resources/Sounds/Loops/' + playFileName;
    end;
end;

procedure TfrmSampleLibrary.btnFavClick(Sender: TObject);
var
  sampleDB : TSamplesArray;
  s : TSamples;
  pos, count : Integer;
begin
  pos := liSamples.ItemIndex;
  count := liSamples.Items.Count;

  s := liSamples.Items.Objects[liSamples.ItemIndex] as TSamples;

  sampleDB := TSamplesArray.Create('db.mdb');


  If s.getFavourite = 'True' then
    begin
      sampleDB.setFavourite(s.getSampleID, 'False');
      btnFavourite.Font.Color := clGray;
      s.setFavourite('False');
    end

  else if s.getFavourite = 'False' then
    begin
      sampleDB.setFavourite(s.getSampleID, 'True');
      btnFavourite.Font.Color := clYellow;
      s.setFavourite('True');
    end;

  If liCat.ItemIndex = 1 then
    begin
      If count = 1 then
        begin
          liSamples.Items.Delete(pos);
          btnPlaySample.Enabled := False;
          lblSampleName.Caption := '';
          lblInstrument.Caption := '';
          btnFavourite.Enabled := False;
        end
      else if pos = count -1 then
        begin
          liSamples.Items.Delete(pos);
          liSamples.ItemIndex := pos -1;
          s := liSamples.Items.Objects[liSamples.ItemIndex] as TSamples;
          lblSampleName.Caption := s.getSampleName;
          lblInstrument.Caption := s.getInstrument;
          playFileName := s.getFileName;
          sampleID := s.getSampleID;
          btnFavourite.Font.Color := clYellow;
        end
      else
        begin
          liSamples.Items.Delete(pos);
          liSamples.ItemIndex := pos;
          s := liSamples.Items.Objects[liSamples.ItemIndex] as TSamples;
          lblSampleName.Caption := s.getSampleName;
          lblInstrument.Caption := s.getInstrument;
          playFileName := s.getFileName;
          sampleID := s.getSampleID;
          btnFavourite.Font.Color := clYellow;
        end;
    end
  else
    begin
      liSamples.ItemIndex := pos;
    end;
end;

procedure TfrmSampleLibrary.btnPlaysSampleClick(Sender: TObject);
begin

  //Check - player is playing

  If playerPreview.Paused = True then
    begin
      playerPreview.Start;
      playerPreview.Resume;                //Play Sample Wav
    end
  else
    begin                                  //Stop sample wav and reset
      playerPreview.Stop;
      playerPreview.Paused := True;
    end;
end;

procedure TfrmSampleLibrary.btnloaClick(Sender: TObject);
var
  i : Integer;
  b : TButtons;
begin
  //Check for loading already active

  If tag = 0 then      {button is not active - initiate load mode}
    begin
      tag := 1;


      //Disable other components

      btnClearSample.Enabled := False;
      btnFavourite.Enabled := False;
      btnPlaySample.Enabled := False;     {Sample Library}
      liCat.Enabled := False;
      liSamples.Enabled := False;
      liSubCat.Enabled := False;

      frmSampleLaunchPad.btnPlayMaster.Enabled := False;
      frmSampleLaunchPad.btnPerformanceMode.Enabled := False;
      frmSampleLaunchPad.btnCloseProject.Enabled := False;         {Sample Launch Pad}
      frmSampleLaunchPad.btnSave.Enabled := False;



      //ButtonImage and Label Configuration

      for i := 1 to 64 do
        begin
          b := Unit1.buttons[i].data;
          Unit1.buttons[i].OnClick := Unit1.frmSampleLaunchPad.LoadEvent;
          Unit1.labels[i].OnClick := Unit1.frmSampleLaunchPad.LoadEvent;
          if b.getID <> 0 then
            begin
              if b.getID = Selected.getSampleID then
                begin
                  Unit1.buttons[i].Enabled := False;
                  Unit1.labels[i].Enabled := False;
                end
              else
                begin
                  Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlueInv.jpg');
                end;
            end
          else
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreyInv.jpg');
            end;
        end;

    end
  else             {button is active - Return to normal mode}
    begin
    tag := 0;

    //Enable other components

      btnClearSample.Enabled := True;
      btnFavourite.Enabled := True;
      btnPlaySample.Enabled := True;     {Sample Library}
      liCat.Enabled := True;
      liSamples.Enabled := True;
      liSubCat.Enabled := True;

      frmSampleLaunchPad.btnPlayMaster.Enabled := True;
      frmSampleLaunchPad.btnPerformanceMode.Enabled := True;
      frmSampleLaunchPad.btnCloseProject.Enabled := True;         {Sample Launch Pad}
      frmSampleLaunchPad.btnSave.Enabled := True;

      for i := 1 to 64 do
        begin
          b := Unit1.buttons[i].data;
          Unit1.buttons[i].Enabled := True;
          Unit1.labels[i].Enabled := True;
          Unit1.buttons[i].OnClick := Unit1.frmSampleLaunchPad.ButtonsEvent;
          Unit1.labels[i].OnClick := Unit1.frmSampleLaunchPad.ButtonsEvent;
          if b.getID <> 0 then
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlue.jpg');
            end
          else
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGrey.jpg');
            end;


        end;
    end;

end;

procedure TfrmSampleLibrary.btnClearSampleClick(Sender: TObject);
var
  i : Integer;
  b : TButtons;
begin

  If tag = 0 then
    begin
      tag := 1;

      //Disable other Components

      btnLoadSample.Enabled := False;
      btnFavourite.Enabled := False;
      btnPlaySample.Enabled := False;     {Sample Library}
      liCat.Enabled := False;
      liSamples.Enabled := False;
      liSubCat.Enabled := False;

      frmSampleLaunchPad.btnPlayMaster.Enabled := False;
      frmSampleLaunchPad.btnPerformanceMode.Enabled := False;
      frmSampleLaunchPad.btnCloseProject.Enabled := False;         {Sample Launch Pad}
      frmSampleLaunchPad.btnSave.Enabled := False;

      //ButtonImage and Label Configuration

      for i := 1 to 64 do
        begin
          b := Unit1.buttons[i].data;
          if b.getID <> 0 then
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlueInv.jpg');
              Unit1.buttons[i].OnClick := Unit1.frmSampleLaunchPad.ClearEvent;
              Unit1.labels[i].OnClick := Unit1.frmSampleLaunchPad.ClearEvent;
            end
          else
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreyInv.jpg');
              Unit1.buttons[i].Enabled := False;
            end;
        end;

    end
  else
    begin
      tag := 0;

      //Enabel other components

      btnLoadSample.Enabled := True;
      btnFavourite.Enabled := True;
      btnPlaySample.Enabled := True;     {Sample Library}
      liCat.Enabled := True;
      liSamples.Enabled := True;
      liSubCat.Enabled := True;

      frmSampleLaunchPad.btnPlayMaster.Enabled := True;
      frmSampleLaunchPad.btnPerformanceMode.Enabled := True;
      frmSampleLaunchPad.btnCloseProject.Enabled := True;         {Sample Launch Pad}
      frmSampleLaunchPad.btnSave.Enabled := True;

      for i := 1 to 64 do
        begin
          b := Unit1.buttons[i].data;
          Unit1.buttons[i].Enabled := True;
          Unit1.labels[i].Enabled := True;
          Unit1.buttons[i].OnClick := Unit1.frmSampleLaunchPad.ButtonsEvent;
          Unit1.labels[i].OnClick := Unit1.frmSampleLaunchPad.ButtonsEvent;
          if b.getID <> 0 then
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlue.jpg');
            end
          else
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGrey.jpg');
            end;
        end;
    end;

end;

procedure TfrmSampleLibrary.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmSampleLibrary.Visible := False;
end;

procedure TfrmSampleLibrary.liCatDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Colours: array[1..2] of integer;
begin

  //Create alternating colours in list boxes

  Colours[1] := clMedGray;
  Colours[2] := clSilver;

  if index = liCat.ItemIndex then
    begin
      with (Control as TListBox).Canvas do
      begin
        Brush.Color := clInactiveCaption;            {Selected sample is highlighted blue}
        FillRect(Rect);
        TextOut(Rect.Left,Rect.Top,liCat.Items[index]);
      end;
    end
  else
    begin
      with (Control as TListBox).Canvas do
      begin
        Brush.Color := Colours[(Index+1) MOD 2 + 1];
        FillRect(Rect);
        TextOut(Rect.Left,Rect.Top,liCat.Items[index]);
      end;
    end;

end;

procedure TfrmSampleLibrary.liSubCatDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Colours: array[1..2] of integer;
begin

  //Create alternating colours in list boxes

  Colours[1] := clMedGray;
  Colours[2] := clSilver;

  if index = liSubCat.ItemIndex then
    begin
      with (Control as TListBox).Canvas do
      begin                                   {Selected sample is highlighted blue}
        Brush.Color := clSkyBlue;
        FillRect(Rect);
        TextOut(Rect.Left,Rect.Top,liSubCat.Items[index]);
      end;
    end
  else
    begin
      with (Control as TListBox).Canvas do
      begin
        Brush.Color := Colours[(Index+1) MOD 2 + 1];
        FillRect(Rect);
        TextOut(Rect.Left,Rect.Top,liSubCat.Items[index]);
      end;
    end;

end;

procedure TfrmSampleLibrary.liSamplesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Colours: array[1..2] of integer;
begin

  //Create alternating colours in list boxes

  Colours[1] := clMedGray;
  Colours[2] := clSilver;

  if index = liSamples.ItemIndex then
    begin
      with (Control as TListBox).Canvas do
      begin                                     {Selected sample is highlighted blue}
        Brush.Color := clSkyBlue;
        FillRect(Rect);
        TextOut(Rect.Left,Rect.Top,liSamples.Items[index]);
      end;
    end
  else
    begin
      with (Control as TListBox).Canvas do
      begin
        Brush.Color := Colours[(Index+1) MOD 2 + 1];
        FillRect(Rect);
        TextOut(Rect.Left,Rect.Top,liSamples.Items[index]);
      end;
    end;

end;

procedure TfrmSampleLibrary.btnPlaySampleClick(Sender: TObject);
begin

  //Check - player is playing

  If playerPreview.Paused = True then
    begin
      playerPreview.Start;
      playerPreview.Resume;                //Play Sample Wav
      btnPlaySample.Font.Color := clMaroon;   {change button graphics}
      btnPlaySample.Caption := ';';
    end
  else
    begin                                  //Stop sample wav and reset
      playerPreview.Stop;
      playerPreview.Paused := True;
      btnPlaySample.Font.Color := clGreen;      {change button graphics}
      btnPlaySample.Caption := '4';
    end;
end;

procedure TfrmSampleLibrary.btnLoadSampleClick(Sender: TObject);
var
  i : Integer;
  b : TButtons;
  sure : integer;
begin
    //Check for loading already active

  If tag = 0 then      {button is not active - initiate load mode}
    begin
      if Selected.getTempo <> tempo then     {Check if tempo of sample is same as project}
        begin
          sure := MessageDlg( 'Warning: Project tempo and Sample tempo do not match. Proceed Anyway', mtCustom, [mbYes, mbNo], 0);
        end
      else
        begin
          sure := mrYes;
        end;
      if sure = mrYes then        {Proceed and initiate load mode - else do nothing}
        begin
          tag := 1;

          //Change panel graphics
          btnLoadSample.Color := $00C7DC05;
          btnLoadSample.Font.Color := clYellow;

          //Hide other components
          pnlHideTop.Visible := True;
          pnlHideBottom.Visible := True;
          pnlHideTop.BringToFront;

          pnlHideBottom.BringToFront;

          frmSampleLaunchPad.pnlHideTop.Visible := True;
          frmSampleLaunchPad.pnlHideMiddle.Visible := True;
          frmSampleLaunchPad.redNotePad.Visible := False;
          frmSampleLaunchPad.pnlHideTop.BringToFront;
          frmSampleLaunchPad.pnlHideMiddle.BringToFront;

          frmSampleLaunchPad.Color := $00330000;

          {Change component descriptions to suit load mode}
          btnLoadSample.Hint := 'LOAD MODE#Press a launch button on the Sample Launch Pad to load the selected sample.##';
          frmSampleLaunchPad.Hint := 'LOAD MODE#Press a launch button on the Sample Launch Pad to load the selected sample.##';

          //ButtonImage and Label Configuration

          for i := 1 to 64 do
            begin
              b := Unit1.buttons[i].data;
              Unit1.buttons[i].OnClick := Unit1.frmSampleLaunchPad.LoadEvent;
              Unit1.labels[i].OnClick := Unit1.frmSampleLaunchPad.LoadEvent;
              Unit1.buttons[i].Hint := 'LOAD MODE#Click to load sample.#Press Load to deactivate LOAD MODE#';
              Unit1.labels[i].Hint := 'LOAD MODE#Click to load sample.#Press Load to deactivate LOAD MODE#';
              if b.getID <> 0 then
                begin
                  if b.getID = Selected.getSampleID then
                    begin
                      Unit1.buttons[i].Enabled := False;
                      Unit1.labels[i].Enabled := False;
                    end
                  else
                    begin
                      Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlueInv.jpg');
                    end;
                end
              else
                begin
                  Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreyInv.jpg');
                end;
            end;
        end;

    end
  else             {button is active - Return to normal mode}
    begin
    tag := 0;

    //Change panel graphics
    btnLoadSample.Color := clSilver;
    btnLoadSample.Font.Color := clTeal;

    //Show other components
    pnlHideTop.Visible := False;
    pnlHideBottom.Visible := False;

    frmSampleLaunchPad.pnlHideTop.Visible := False;
    frmSampleLaunchPad.pnlHideMiddle.Visible := False;
    frmSampleLaunchPad.redNotePad.Visible := True;

    frmSampleLaunchPad.Color := clGray;

    {Change component descriptions to suit load mode}
    btnLoadSample.Hint := 'Load Sample#Select to load the selected sample to a launch button on the Sample Launch Pad.##';
    frmSampleLaunchPad.Hint := 'Sample Launch Pad#The performance hub of your project.##';


      for i := 1 to 64 do
        begin
          b := Unit1.buttons[i].data;
          Unit1.buttons[i].Enabled := True;
          Unit1.labels[i].Enabled := True;
          Unit1.buttons[i].OnClick := Unit1.frmSampleLaunchPad.ButtonsEvent;
          Unit1.labels[i].OnClick := Unit1.frmSampleLaunchPad.ButtonsEvent;
          Unit1.buttons[i].Hint := 'Sample Launch Buttons#Play assigned samples in a loop#ctrl + H for more info. Enable Performance Mode and press Master Play to enable:#l | 4';
          Unit1.labels[i].Hint := 'Sample Launch Buttons#Play assigned samples in a loop#ctrl + H for more info. Enable Performance Mode and press Master Play to enable:#l | 4';
          if b.getID <> 0 then
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlue.jpg');
            end
          else
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGrey.jpg');
            end;


        end;
    end;

end;

procedure TfrmSampleLibrary.btnFavouriteClick(Sender: TObject);
var
  sampleDB : TSamplesArray;
  s : TSamples;
  pos, count : Integer;
begin

  pos := liSamples.ItemIndex;
  count := liSamples.Items.Count;

  s := liSamples.Items.Objects[liSamples.ItemIndex] as TSamples;

  sampleDB := TSamplesArray.Create('db.mdb');


  If s.getFavourite = 'True' then
    begin
      sampleDB.setFavourite(s.getSampleID, 'False');
      btnFavourite.Font.Color := clGray;
      s.setFavourite('False');
    end

  else if s.getFavourite = 'False' then
    begin
      sampleDB.setFavourite(s.getSampleID, 'True');
      btnFavourite.Font.Color := clYellow;
      s.setFavourite('True');
    end;

  If liCat.ItemIndex = 1 then
    begin
      If count = 1 then
        begin
          liSamples.Items.Delete(pos);
          btnPlaySample.Enabled := False;
          lblSampleName.Caption := '';
          lblInstrument.Caption := '';
          btnFavourite.Enabled := False;
        end
      else if pos = count -1 then
        begin
          liSamples.Items.Delete(pos);
          liSamples.ItemIndex := pos -1;
          s := liSamples.Items.Objects[liSamples.ItemIndex] as TSamples;
          lblSampleName.Caption := s.getSampleName;
          lblInstrument.Caption := s.getInstrument;
          playFileName := s.getFileName;
          sampleID := s.getSampleID;
          btnFavourite.Font.Color := clYellow;
        end
      else
        begin
          liSamples.Items.Delete(pos);
          liSamples.ItemIndex := pos;
          s := liSamples.Items.Objects[liSamples.ItemIndex] as TSamples;
          lblSampleName.Caption := s.getSampleName;
          lblInstrument.Caption := s.getInstrument;
          playFileName := s.getFileName;
          sampleID := s.getSampleID;
          btnFavourite.Font.Color := clYellow;
        end;
    end
  else
    begin
      liSamples.ItemIndex := pos;
    end;

end;

procedure TfrmSampleLibrary.btnPlaySampleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TPanel).BevelOuter := bvLowered;   {Panel click animation}
end;

procedure TfrmSampleLibrary.btnPlaySampleMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TPanel).BevelOuter := bvRaised;      {Panel click animation}
end;

procedure TfrmSampleLibrary.btnPlaySampleMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  helpString : string;
begin
  (Sender as TPanel).BevelOuter := bvRaised;  {Make panel outline noticable}
  helpString := (Sender AS TPanel).Hint;

  If (Sender as TPanel).Name = 'btnFavourite'  then
    begin
      btnLoadSample.BevelOuter := bvNone;  {Make panel outlines of load button disappear}
    end;

  If (Sender as TPanel).Name = 'btnLoadSample'  then
    begin
      btnFavourite.BevelOuter := bvNone;  {Make panel outlines of favourite button disappear}
    end;

  {output help to richedit}
  frmSampleLaunchPad.redHelp.Clear;

  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Color := clYellow;
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Style := [fsBold];
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 9;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13 + #13);

  delete(helpString, 1, pos('#', helpString) );
  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Style := [];
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 9;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13 + #13);

  delete(helpString, 1, pos('#', helpString) );
  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 8;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13);

  delete(helpString, 1, pos('#', helpString) );
  If length(helpString) > 0 then
    begin
      frmSampleLaunchPad.redHelp.SelAttributes.Size := 14;
      frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Webdings';
      frmSampleLaunchPad.redHelp.SelAttributes.Charset := SYMBOL_CHARSET;
      frmSampleLaunchPad.redHelp.Lines.Add(helpString);
    end;
end;



procedure TfrmSampleLibrary.btnFavouriteExit(Sender: TObject);
begin
  (Sender as TPanel).BevelOuter := bvNone;
end;

procedure TfrmSampleLibrary.pnlSampleInfoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  helpString : string;
begin
  If Sender.ClassName = 'TPanel' then
    begin
      helpString := (Sender AS TPanel).Hint;
    end
  else
    if Sender.ClassName = 'TPageControl' then
      begin
        helpString := (Sender AS TPageControl).Hint;
      end
  else
    if Sender.ClassName = 'TTabSheet' then
      begin
        helpString := (Sender AS TTabSheet).Hint;
      end
  else
    if Sender.ClassName = 'TListBox' then
      begin
        helpString := (Sender AS TListBox).Hint;
      end;

  btnPlaySample.BevelOuter := bvNone;    {Make "button" panel outlines disappear}
  btnLoadSample.BevelOuter := bvNone;
  btnFavourite.BevelOuter := bvNone;
  btnClearSample.BevelOuter := bvNone;
  btnAddSample.BevelOuter := bvNone;



  {output help to richedit}
  frmSampleLaunchPad.redHelp.Clear;

  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Color := clYellow;
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Style := [fsBold];
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 9;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13 + #13);

  delete(helpString, 1, pos('#', helpString) );
  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Style := [];
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 9;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13 + #13);

  delete(helpString, 1, pos('#', helpString) );
  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 8;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13);

  delete(helpString, 1, pos('#', helpString) );
  If length(helpString) > 0 then
    begin
      frmSampleLaunchPad.redHelp.SelAttributes.Size := 14;
      frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Webdings';
      frmSampleLaunchPad.redHelp.SelAttributes.Charset := SYMBOL_CHARSET;
      frmSampleLaunchPad.redHelp.Lines.Add(helpString);
    end;

end;

procedure TfrmSampleLibrary.Panel1Click(Sender: TObject);
var
  i : Integer;
  b : TButtons;
begin

  If tag = 0 then        {Clear mode is off - Activate}
    begin
      tag := 1;

      //Change panel graphics
      btnClearSample.Color := $00C7DC05;
      btnClearSample.Font.Color := clYellow;

      ///Hide other components
      pnlHide1.Visible := True;
      pnlHide2.Visible := True;
      pnlHide1.BringToFront;
      pnlHide2.BringToFront;

      frmSampleLaunchPad.pnlHideTop.Visible := True;
      frmSampleLaunchPad.pnlHideMiddle.Visible := True;
      frmSampleLaunchPad.redNotePad.Visible := False;
      frmSampleLaunchPad.pnlHideTop.BringToFront;
      frmSampleLaunchPad.pnlHideMiddle.BringToFront;

      frmSampleLaunchPad.Color := $00330000;

      {Change component descriptions to suit load mode}
      btnClearSample.Hint := 'CLEAR MODE#Press a launch button on the Sample Launch Pad to clear its sample.##';
      frmSampleLaunchPad.Hint := 'CLEAR MODE#Press a launch button on the Sample Launch Pad to clear its sample.##';


      //ButtonImage and Label Configuration

      for i := 1 to 64 do
        begin
          b := Unit1.buttons[i].data;
          if b.getID <> 0 then
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlueInv.jpg');
              Unit1.buttons[i].OnClick := Unit1.frmSampleLaunchPad.ClearEvent;
              Unit1.labels[i].OnClick := Unit1.frmSampleLaunchPad.ClearEvent;
              Unit1.buttons[i].Hint := 'CLEAR MODE#Click to clear sample#Press Clear a Sample to deactivate CLEAR MODE#';
              Unit1.labels[i].Hint := 'CLEAR MODE#Click to clear sample#Press Clear a Sample to deactivate CLEAR MODE#';
            end
          else
            begin
              Unit1.buttons[i].Hint := 'CLEAR MODE#Already cleared.#Click a launch button to clear sample. Press Clear a Sample to deactivate CLEAR MODE#';
              Unit1.labels[i].Hint := 'CLEAR MODE#Already cleared.#Click a launch button to clear sample. Press Clear a Sample to deactivate CLEAR MODE#';
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGreyInv.jpg');
              Unit1.buttons[i].Enabled := False;
            end;
        end;

    end
  else                    {Clear mode is on - deactivate}
    begin
      tag := 0;

      //Change panel graphics
      btnClearSample.Color := clSilver;
      btnClearSample.Font.Color := clMaroon;

      //Show other components
      pnlHide1.Visible := False;
      pnlHide2.Visible := False;

      frmSampleLaunchPad.pnlHideTop.Visible := False;
      frmSampleLaunchPad.pnlHideMiddle.Visible := False;
      frmSampleLaunchPad.redNotePad.Visible := True;

      frmSampleLaunchPad.Color := clGray;

      {Change component descriptions to suit load mode}
      btnLoadSample.Hint := 'Load Sample#Select to load the selected sample to a launch button on the Sample Launch Pad.##';
      frmSampleLaunchPad.Hint := 'Sample Launch Pad#The performance hub of your project.##';


      for i := 1 to 64 do
        begin
          b := Unit1.buttons[i].data;
          Unit1.buttons[i].Enabled := True;
          Unit1.labels[i].Enabled := True;
          Unit1.buttons[i].OnClick := Unit1.frmSampleLaunchPad.ButtonsEvent;
          Unit1.labels[i].OnClick := Unit1.frmSampleLaunchPad.ButtonsEvent;
          Unit1.buttons[i].Hint := 'Sample Launch Buttons#Play assigned samples in a loop#ctrl + H for more info. Enable Performance Mode and press Master Play to enable:#l | 4';
          Unit1.labels[i].Hint := 'Sample Launch Buttons#Play assigned samples in a loop#ctrl + H for more info. Enable Performance Mode and press Master Play to enable:#l | 4';
          if b.getID <> 0 then
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadBlue.jpg');
            end
          else
            begin
              Unit1.buttons[i].Picture.LoadFromFile(application.GetNamePath + 'Resources/Images/PadGrey.jpg');
            end;
        end;
    end;

end;

procedure TfrmSampleLibrary.btnLoadSampleMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    (Sender as TPanel).BevelOuter := bvRaised;  {Make panel outline noticable}
    btnFavourite.BevelOuter := bvNone;        {Make panel outlines of favourites button disappear}
end;

procedure TfrmSampleLibrary.btnFavouriteMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    (Sender as TPanel).BevelOuter := bvRaised;  {Make panel outline noticable}
    btnLoadSample.BevelOuter := bvNone;        {Make panel outlines of load button disappear}
end;

procedure TfrmSampleLibrary.btnAddSampleClick(Sender: TObject);
var
  sampleDB : TSamplesArray;
begin
  frmAddSample.Show;

  sampleDB := TSamplesArray.Create('db.mdb');                              
  liSamples.Items := sampleDB.getAllSamples;
  samplesList := sampleDB.getAllSamples;
  {Disable other forms}
  frmSampleLibrary.Enabled := False;
  frmSampleLaunchPad.Enabled := False;

end;

procedure PopulateLiSamples;
var
  sampleDB : TSamplesArray;
begin

  sampleDB := TSamplesArray.Create('db.mdb');
  {populate liSamples with all samples}
  frmSampleLibrary.liSamples.Items := sampleDB.getAllSamples;
  uSampleLibrary.SamplesList := sampleDb.getAllSamples;
  frmSampleLibrary.liSamples.ItemIndex := 0;
  frmSampleLibrary.liSubCat.Clear;
end;



procedure TfrmSampleLibrary.tagTileClick(Sender: TObject);
var
  i,
  counter,
  index : integer;
  sampleDB : TSamplesArray;
begin
  //Onclick event for all tag tile panels

  sampleDB := TSamplesArray.Create('db.mdb');

  {check if panel is reset tile}
  if (Sender as TPanel).Caption = 'Reset' then    {panel is reset tile}
    begin
      Reset; {call the reset procedure - Also used by frmAddSample}
    end
  else     {panel is a tag tile}
    begin
      if (Sender AS TPanel).tag = 0 then    {tag tile is inactive}
        begin
          (Sender AS TPanel).tag := 1;
          {change graphics}
            (Sender as TPanel).Color := clMenuHighlight;
            (Sender as TPanel).Font.Color := clCream;
        end
      else               {tag tile is active}
        begin
          (Sender AS TPanel).tag := 0;
          {change graphics}
            (Sender as TPanel).Color := clSkyBlue;
            (Sender as TPanel).Font.Color := clBtnText;
        end;

      tagCombination := TStringList.Create;

      for i := 2 to tagTilesCount do
        begin
          if arrTagTiles[i].Tag = 1 then
            begin
              tagCombination.Add(arrTagTiles[i].Caption);
            end;
        end;

      if tagCombination.Count > 0 then
        begin
        {change reset tile graphics}
          arrTagTiles[1].Enabled := True;
          arrTagTiles[1].Color := $008080FF;
          arrTagTiles[1].Font.Color := clMaroon;
          application.ProcessMessages;
        end;

      if tagCombination.Count = 0 then
        begin
          {change reset tile graphics to disabled}
            arrTagTiles[1].Enabled := False;
            arrTagTiles[1].Color := clMedGray;
            arrTagTiles[1].Font.Color := clGray;
        end;

      possibleTags := sampleDB.possibleTags(tagCombination, false);
      possibleTags.Sort;
      for i := 2 to tagTilesCount do
        begin
          If possibleTags.Find(arrTagTiles[i].Caption, index) then
            begin
              arrTagTiles[i].Enabled := True;
              arrTagTiles[i].Color := clSkyBlue;
              arrTagTiles[i].Font.Color := clBtnText;
            end
          else
            begin
              if arrTagTiles[i].Tag = 0 then
                begin
                  arrTagTiles[i].Enabled := False;
                  arrTagTiles[i].Color := clMedGray;
                  arrTagTiles[i].Font.Color := clGray;
                end;
            end;
        end;

    {Fill Samples list box}

      if tagCombination.Count = 0 then
        begin
          liSamples.Items := sampleDB.getAllSamples;
          samplesList := sampleDB.getAllSamples;
        end
      else
        begin
          liSamples.Items := sampleDB.possibleTags(tagCombination, true);
          SamplesList := sampleDB.possibleTags(tagCombination, true);
          liSamples.ItemIndex := 0;
        end;

    end;

    tagCombination.Destroy;
    possibleTags.Destroy;

    //Select first sample
      SelectFirstSample;

end;

procedure TfrmSampleLibrary.pgCtrlViewChange(Sender: TObject);
var
  sampleDb : TSamplesArray;
  s : TSamples;
begin
  sampleDB := TSamplesArray.Create('db.mdb');

  liCat.Items := sampleDB.getCategories;
  liCat.ItemIndex := 0;
  liSamples.Items := sampleDB.getAllSamples;
  SamplesList := sampleDB.getAllSamples;

  //SELECT FIRST SAMPLE

  SelectFirstSample;

end;

procedure SelectFirstSample;
var
  s : TSamples;
begin

//SELECT FIRST SAMPLE
  If frmSampleLibrary.liSamples.Items.Count > 0 then
    begin
    frmSampleLibrary.liSamples.ItemIndex := 0;

    s := frmSampleLibrary.liSamples.Items.Objects[frmSampleLibrary.liSamples.ItemIndex] as TSamples;
    uSampleLibrary.Selected := s;

    frmSampleLibrary.lblSampleName.Caption := s.getSampleName;
    frmSampleLibrary.lblInstrument.Caption := s.getInstrument + '  ' + FloatToStr(s.getTempo) + ' bpm';
    playFileName := s.getFileName;
    sampleID := s.getSampleID;

    //Load selected sample to sample player
    //Req: new sample is not already playing
    If frmSampleLibrary.playerPreview.FileName <> application.GetNamePath + 'Resources/Sounds/Loops/' + playFileName then
      begin
        frmSampleLibrary.playerPreview.Stop;
        frmSampleLibrary.playerPreview.Paused := True;
        frmSampleLibrary.playerPreview.FileName := application.GetNamePath + 'Resources/Sounds/Loops/' + playFileName;
      end;

    //Set Favourites Image
    If s.getFavourite = 'True' then
      begin
        frmSampleLibrary.btnFavourite.Font.Color := clYellow;
      end;

    If s.getFavourite = 'False' then
      begin
        frmSampleLibrary.btnFavourite.Font.Color := clGray;
      end;
    frmSampleLibrary.btnFavourite.Enabled := True;
    frmSampleLibrary.btnPlaySample.Enabled := True;

  end;

end;

{Creates a new sample in the database and adds to sample library}
procedure NewSample;
var
  sampleDB : TSamplesArray;
begin
  sampleDB := TSamplesArray.Create('db.mdb');
  sampleDB.newSample(frmAddSample.edtSampleName.Text, frmAddSample.edtSampleName.Text + '.wav', frmAddSample.cmbInstrument.Items[frmAddSample.cmbInstrument.ItemIndex], frmAddSample.cmbGenre.Items[frmAddSample.cmbGenre.ItemIndex], frmAddSample.spnedtTempo.Value, frmAddSample.spnedtBars.Value, uFrmAddSample.arrTags);
end;

procedure TfrmSampleLibrary.pgCtrlViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  helpString : string;
begin

  helpString := (Sender as TPageControl).Hint;

  btnPlaySample.BevelOuter := bvNone;    {Make "button" panel outlines disappear}
  btnLoadSample.BevelOuter := bvNone;
  btnFavourite.BevelOuter := bvNone;
  btnClearSample.BevelOuter := bvNone;
  btnAddSample.BevelOuter := bvNone;



  {output help to richedit}
  frmSampleLaunchPad.redHelp.Clear;

  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Color := clYellow;
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Style := [fsBold];
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 9;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13 + #13);

  delete(helpString, 1, pos('#', helpString) );
  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Style := [];
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 9;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13 + #13);

  delete(helpString, 1, pos('#', helpString) );
  frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Arial';
  frmSampleLaunchPad.redHelp.SelAttributes.Charset := ANSI_CHARSET;
  frmSampleLaunchPad.redHelp.SelAttributes.Size := 8;
  frmSampleLaunchPad.redHelp.Lines.Add(copy(helpString, 1, pos('#', helpString) - 1) + #13);

  delete(helpString, 1, pos('#', helpString) );
  If length(helpString) > 0 then
    begin
      frmSampleLaunchPad.redHelp.SelAttributes.Size := 14;
      frmSampleLaunchPad.redHelp.SelAttributes.Name := 'Wingdings';
      frmSampleLaunchPad.redHelp.SelAttributes.Charset := SYMBOL_CHARSET;
      frmSampleLaunchPad.redHelp.Lines.Add(helpString);
    end;

end;

Procedure Reset;             {Reset the Tile View interface}
var
  i,
  index : integer;
  sampleDB : TSamplesArray;
begin

  sampleDB := TSamplesArray.Create('db.mdb');

{change reset tile graphics}
        arrTagTiles[1].Enabled := True;
        arrTagTiles[1].Color := clMedGray;
        arrTagTiles[1].Font.Color := clGray;
      {reset the tag tiles}

      tagCombination := TStringList.Create;

      possibleTags := sampleDB.possibleTags(tagCombination, false);

      possibleTags.Sort;
      for i := 2 to tagTilesCount do
      begin
        arrTagTiles[i].Tag := 0;
        If possibleTags.Find(arrTagTiles[i].Caption, index) = false then
          begin
            arrTagTiles[i].Enabled := False;
            arrTagTiles[i].Color := clMedGray;
            arrTagTiles[i].Font.Color := clGray;
          end
        else
          begin
            arrTagTiles[i].Enabled := True;
            arrTagTiles[i].Color := clSkyBlue;
            arrTagTiles[i].Font.Color := clBtnText;
          end;
      end;
      {fill Samples list box with all samples}
        frmSampleLibrary.liSamples.Items := sampleDB.getAllSamples;
        SamplesList := sampleDb.getAllSamples;
        frmSampleLibrary.liSamples.ItemIndex := 0;
end;

end.


