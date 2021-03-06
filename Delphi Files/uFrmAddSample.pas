unit uFrmAddSample;

interface

uses
  Windows, Messages, SysUtils, Variants, Math, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin, ALAudioOut, ALCommonPlayer,
  ALWavePlayer, mmSystem, WaveUtils, WaveStorage, WaveIO, WaveOut,
  WavePlayers, uSamplesArray, ADODB, DB;

type
  TfrmAddSample = class(TForm)
    lblSelectWaveFile: TLabel;
    lblInstrument: TLabel;
    lblMoods: TLabel;
    lblGenre: TLabel;
    dlgOpenFile: TOpenDialog;
    edtFileName: TEdit;
    btnBrowse: TButton;
    cmbGenre: TComboBox;
    chk5: TCheckBox;
    cmbInstrument: TComboBox;
    pnlMoods: TPanel;
    pnlInstrument: TPanel;
    pnlGenre: TPanel;
    pnlSelectFile: TPanel;
    chk1: TCheckBox;
    chk6: TCheckBox;
    chk3: TCheckBox;
    chk7: TCheckBox;
    chk8: TCheckBox;
    chk4: TCheckBox;
    chk2: TCheckBox;
    btnAddSample: TButton;
    btnCancel: TButton;
    lblErrorGenre: TLabel;
    lblErrorInstrument: TLabel;
    lblErrorFileName: TLabel;
    lblTempo: TLabel;
    spnedtTempo: TSpinEdit;
    btnPlaySample: TPanel;
    lblWaveFile: TLabel;
    lblBars: TLabel;
    spnedtBars: TSpinEdit;
    lblName: TLabel;
    edtSampleName: TEdit;
    lblErrorSampleName: TLabel;
    waveStorage: TWaveStorage;
    playerPreview: TALWavePlayer;
    audioOutPreview: TALAudioOut;
    lblErrorNameTaken: TLabel;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnAddSampleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbInstrumentChange(Sender: TObject);
    procedure cmbGenreChange(Sender: TObject);
    procedure btnPlaySampleClick(Sender: TObject);
    procedure edtSampleNameChange(Sender: TObject);
    procedure checkBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure EnableComponents;
  procedure DisableComponents;

var
  frmAddSample: TfrmAddSample;
  filename : string;
  arrTags : TStringList;

implementation

{$R *.dfm}

uses uSampleLibrary, Unit1;

procedure TfrmAddSample.btnBrowseClick(Sender: TObject);
begin

  playerPreview.Stop;              {Stop preview player}
  playerPreview.Paused := True;
  btnPlaySample.Font.Color := clGreen;      {change preview button graphics}
  btnPlaySample.Caption := '4';
  
  {execute an open file dialog}
  if dlgOpenFile.Execute then
    begin
      {check if file exists}
      if FileExists(dlgOpenFile.FileName) then
        {if file exists, load filename into edit box}
        begin
          edtFileName.Text := dlgOpenFile.FileName;
          waveStorage.Wave.LoadFromFile(dlgOpenFile.FileName);
          playerPreview.FileName := dlgOpenFile.FileName;
          EnableComponents;
          edtFileName.Color := clGradientInactiveCaption;      {Return graphics to normal incase highlighted}
          lblErrorFileName.Visible := false;

          {Autofill Sample Name edit box}
          edtSampleName.Text := copy( ExtractFileName(edtFileName.Text), 1, (pos('.', ExtractFileName(edtFileName.Text))) - 1 );
          edtSampleName.SetFocus;
          if length(edtSampleName.Text) > 0 then   {If no errors in panel, return panel to normal}
            begin
              pnlSelectFile.Color := clMedGray;
            end;
        end
      else
      {otherwise raise an exception}
        begin
          raise Exception.Create('File does not exist');
        end;
    end;

end;

procedure TfrmAddSample.btnCancelClick(Sender: TObject);
begin
  frmAddSample.Close;
end;

procedure EnableComponents;
var
  i : integer;
begin

  {enable other components}

  frmAddSample.lblGenre.Enabled := True;
  frmAddSample.lblMoods.Enabled := True;
  frmAddSample.lblInstrument.Enabled := True;
  frmAddSample.cmbGenre.Enabled := True;
  frmAddSample.cmbInstrument.Enabled := True;
  frmAddSample.btnAddSample.Enabled := True;

  for i := 1 to 8 do
    begin
    (frmAddSample.FindComponent('chk' + IntToStr(i)) AS TCheckBox).Enabled := true;
    end;

  frmAddSample.lblGenre.Font.Color := $00482400;
  frmAddSample.lblMoods.Font.Color := $00482400;
  frmAddSample.lblInstrument.Font.Color := $00482400;

  frmAddSample.pnlGenre.Color := clMedGray;
  frmAddSample.pnlMoods.Color := clMedGray;
  frmAddSample.pnlInstrument.Color := clMedGray;

  frmAddSample.cmbGenre.Color := clInactiveCaption;
  frmAddSample.cmbInstrument.Color := clInactiveCaption;

  frmAddSample.btnPlaySample.Visible := True;

  frmAddSample.lblTempo.Font.Color := $00482400;
  frmAddSample.lblBars.Font.Color := $00482400;
  frmAddSample.lblName.Font.Color := $00482400;
  frmAddSample.spnedtTempo.Color := clInactiveCaption;
  frmAddSample.spnedtBars.Color := clInactiveCaption;
  frmAddSample.edtSampleName.Color := clInactiveCaption;
  frmAddSample.spnedtTempo.Enabled := True;
  frmAddSample.spnedtBars.Enabled := True;
  frmAddSample.edtSampleName.Enabled := True;

  frmAddSample.lblWaveFile.Caption := 'Wave Length: ' + FloatToStr(frmAddSample.waveStorage.Wave.Length) + 'ms' + #13  + 'Bit Rate: ' + FloatToStr(frmAddSample.waveStorage.Wave.BitRate) + 'kbps' + #13 + 'Audio Format: ' + frmAddSample.waveStorage.wave.AudioFormat;
  frmAddSample.lblWaveFile.Visible := True;

end;

procedure DisableComponents;
var
  i : integer;
begin

  {Disable other components}

  frmAddSample.lblGenre.Enabled := False;
  frmAddSample.lblMoods.Enabled := False;
  frmAddSample.lblInstrument.Enabled := False;
  frmAddSample.cmbGenre.Enabled := False;
  frmAddSample.cmbInstrument.Enabled := False;

  for i := 1 to 8 do
    begin
    (frmAddSample.FindComponent('chk' + IntToStr(i)) AS TCheckBox).Enabled := false;
    (frmAddSample.FindComponent('chk' + IntToStr(i)) AS TCheckBox).Checked := false;
    end;  

  frmAddSample.btnAddSample.Enabled := False;

  frmAddSample.lblGenre.Font.Color := clGray;
  frmAddSample.lblMoods.Font.Color := clGray;
  frmAddSample.lblInstrument.Font.Color := clGray;

  frmAddSample.pnlGenre.Color := $008C8C8C;
  frmAddSample.pnlMoods.Color := $008C8C8C;
  frmAddSample.lblTempo.Font.Color := clGray;
  frmAddSample.lblBars.Font.Color :=  clGray;
  frmAddSample.lblName.Font.Color :=  clGray;
  frmAddSample.pnlInstrument.Color := $008C8C8C;

  frmAddSample.cmbGenre.Color := clScrollBar;
  frmAddSample.cmbInstrument.Color := clScrollBar;
  frmAddSample.spnedtTempo.Color := clScrollBar;
  frmAddSample.spnedtBars.Color := clScrollBar;
  frmAddSample.edtSampleName.Color := clScrollBar;
  frmAddSample.spnedtTempo.Enabled := False;
  frmAddSample.spnedtBars.Enabled := False;
  frmAddSample.edtSampleName.Enabled := False;

  frmAddSample.btnPlaySample.Visible := False;
  frmAddSample.lblWaveFile.Visible := False;

end;

procedure TfrmAddSample.btnAddSampleClick(Sender: TObject);
var
  ready : boolean;
  sampleControl : TSamplesArray;
  moods,
  allSamples : TStringList;
  i,
  index : integer;
begin
  ready := true;
  
  {Check sample form for completion}
  
  if cmbGenre.ItemIndex < 0 then          {Genre is unselected}
    begin
      ready := false;
      pnlGenre.Color := $008080FF;          {highlight the error}
      cmbGenre.Color := $008080FF;
      lblErrorGenre.Visible := true;
    end;

  if cmbInstrument.ItemIndex < 0 then      {Instrument is unselected}
    begin
      ready := false;
      pnlInstrument.Color := $008080FF;      {highlight the error}
      cmbInstrument.Color := $008080FF;
      lblErrorInstrument.Visible := true;
    end;

  if Not FileExists(edtFileName.Text) then    {File Not Found}
    begin
      ready := false;
      pnlSelectFile.Color := $008080FF;
      edtFileName.Color := $008080FF;      {highlight the error}
      lblErrorFileName.Visible := true;
    end;

  if length(edtSampleName.Text) = 0 then    {No name given}
    begin
      ready := false;
      pnlSelectFile.Color := $008080FF;
      edtSampleName.Color := $008080FF;      {highlight the error}
      lblErrorSampleName.Visible := true;
    end;

  {Error Check - Sample name does not already exist}

  if ready then
    begin
      {Check that sample name doesn't already exist}
      allSamples := uSampleLibrary.SamplesList;
      allSamples.Sort;
      If allSamples.Find(edtSampleName.Text, index) then
        begin
          ready := False;
          pnlSelectFile.Color := $008080FF;
          edtSampleName.Color := $008080FF;      {highlight the error}
          lblErrorNameTaken.Visible := true;
        end;
    end;
    
  if ready then
    begin
      sampleControl := TSamplesArray.Create('db.mdb');
      SetCurrentDir(ExtractFilePath(Application.ExeName));
      CopyFile(pChar(edtFileName.Text), pChar(GetCurrentDir + '\Resources\Sounds\Loops\' + edtSampleName.Text + '.wav'), False);
      {compile array of tags if checked}
      moods := sampleControl.getMoods(False);
      arrTags := TStringList.Create;
      for i := 1 to 4 do
        begin
          if (FindComponent('chk' + IntToStr(i)) AS TCheckBox).Checked = True then
            begin
              arrTags.Add( moods.Strings[i - 1] );
            end
          else if (FindComponent('chk' + IntToStr(i + 4)) AS TCheckBox).Checked = True then
            begin
              arrTags.Add( moods.Strings[i + 3] );
            end
          else
            begin
              arrTags.Add('none');
            end;
        end;
      SetCurrentDir(ExtractFilePath(Application.ExeName));
      sampleControl.newSample(edtSampleName.Text, edtSampleName.Text + '.wav', cmbInstrument.Items[cmbInstrument.ItemIndex], cmbGenre.Items[cmbGenre.ItemIndex], spnedtTempo.Value, spnedtBars.Value, arrTags);
      {Enable other forms}
      frmSampleLibrary.Enabled := True;
      frmSampleLaunchPad.Enabled := True;
      uSampleLibrary.PopulateLiSamples;
      uSampleLibrary.Reset;
      frmAddSample.Close;
    end;
   
end;

procedure TfrmAddSample.FormShow(Sender: TObject);
var
  comboBoxControl : TSamplesArray;
begin
  DisableComponents;
  edtFileName.Text := '';
  SetCurrentDir(ExtractFilePath(Application.ExeName));
  {Fill combo box}

  comboBoxControl := TSamplesArray.Create('db.mdb');

  cmbGenre.Items := comboBoxControl.getGenres;

end;

procedure TfrmAddSample.cmbInstrumentChange(Sender: TObject);
begin
  If cmbInstrument.ItemIndex > -1 then  {check to see if instrument is selected}
    begin
      pnlInstrument.Color := clMedGray;      {return components to normal graphics}
      lblErrorInstrument.Visible := false;
      cmbInstrument.Color := clGradientInactiveCaption;
    end;
end;

procedure TfrmAddSample.cmbGenreChange(Sender: TObject);
begin
  If cmbGenre.ItemIndex > -1 then    {check to see if genre is selected}
    begin
      pnlGenre.Color := clMedGray;   {return components to normal graphics}
      cmbGenre.Color := clGradientInactiveCaption;
      lblErrorGenre.Visible := false;
    end;
end;

procedure TfrmAddSample.btnPlaySampleClick(Sender: TObject);
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

procedure TfrmAddSample.edtSampleNameChange(Sender: TObject);
begin

  if length(edtSampleName.Text) > 0 then    {Name given}
    begin
      edtSampleName.Color := clGradientInactiveCaption;      {cancel the error graphics}
      lblErrorNameTaken.Visible := false;
      lblErrorSampleName.Visible := false;
      if FileExists(edtFileName.Text) then
        begin
          pnlSelectFile.Color := clMedGray;
        end;
    end;


end;

procedure TfrmAddSample.checkBoxClick(Sender: TObject);
begin
  If (Sender AS TCheckBox).Tag > 0 then
    begin
      (FindComponent('chk' + IntToStr((Sender AS TCheckBox).Tag + 4)) AS TCheckBox).Checked := False;
    end
  else
    begin
      (FindComponent('chk' + IntToStr( - (Sender AS TCheckBox).Tag)) AS TCheckBox).Checked := False;
    end;

end;

procedure TfrmAddSample.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  playerPreview.Stop;              {Stop preview player}
  playerPreview.Paused := True;
  btnPlaySample.Font.Color := clGreen;      {change preview button graphics}
  btnPlaySample.Caption := '4';

  {Reenable other forms}
  frmSampleLibrary.Enabled := True;
  frmSampleLaunchPad.Enabled := True;

end;

end.
