program Project1;

uses
  Forms,
  Start in 'Start.pas' {frmStartMenu},
  uProjects in 'uProjects.pas',
  uProjectsArray in 'uProjectsArray.pas',
  uSampleLibrary in 'uSampleLibrary.pas' {frmSampleLibrary},
  uSamplesArray in 'uSamplesArray.pas',
  uSamples in 'uSamples.pas',
  Unit1 in 'Unit1.pas' {frmSampleLaunchPad},
  uButtons in 'uButtons.pas',
  uButtonImage in 'uButtonImage.pas',
  uFrmAddSample in 'uFrmAddSample.pas' {frmAddSample};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmStartMenu, frmStartMenu);
  Application.CreateForm(TfrmSampleLibrary, frmSampleLibrary);
  Application.CreateForm(TfrmSampleLaunchPad, frmSampleLaunchPad);
  Application.CreateForm(TfrmAddSample, frmAddSample);
  Application.Run;
end.
