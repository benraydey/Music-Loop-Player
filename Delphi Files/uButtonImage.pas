unit uButtonImage;

interface

uses sysUtils, ExtCtrls, uButtons;

{ButtonImage class defines an object that is an extension
 of a TImage object. It adds a parameter that stores an object
 containing data pertaining to the ButtonImage's associated sample}

type TButtonImage = class (TImage)
  private
  
  public
    data : TButtons;     {TButton object stores data pertaining to the ButtonImage's associated sample}
end;

implementation

end.
 