unit uSampleLaunchControl;

interface

uses ADODB, DB, SysUtils, Classes, Dialogs, uButtons, uButtonImage;

type TSampleLaunchControl = class
  private
    conn : TADOConnection;
    id : integer;
  public
    Constructor Create ;

end;

implementation

{ TSampleLaunchControl }

constructor TSampleLaunchControl.Create;
begin

end;

end.
