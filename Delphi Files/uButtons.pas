unit uButtons;

interface

uses SysUtils, Classes, Dialogs;

{Buttons class defines a buttons object. A buttons object
 contains all the data pertaining to a sample
 associated with a particular sample launch button}

type TButtons = class
  private
    SampleID : Integer;
    SampleName : String;
    FileName : String;
    Bars : Integer;
  public
    Constructor Create (id, ba : integer; na, fi : string);   {Instantiates object. Takes in id, bars, name and filename as parameters}
    function getName : string;        {Returns the associated sample's name as a string}
    function getFileName : String;    {Returns the associated sample's filename as a string}
    function getID : Integer;         {Returns the associated sample's id as an integer}
    function getBars : Integer;       {Returns the associated sample's bars value as an integer}

end;

implementation

{ TButtons }

constructor TButtons.Create(id, ba: integer; na, fi: string);
begin

  {Instantiates object. Takes in id, bars, name and filename as parameters}

  SampleID := id;
  SampleName := na;
  FileName := fi;
  Bars := ba;

end;

function TButtons.getBars: Integer;
begin
 Result := Bars;            {Returns the associated sample's bars value as an integer}
end;

function TButtons.getFileName: String;
begin
  Result := FileName;       {Returns the associated sample's filename as a string}
end;

function TButtons.getID: Integer;
begin
  Result := SampleID;       {Returns the associated sample's id as an integer}
end;

function TButtons.getName: string;
begin
  Result := SampleName;     {Returns the associated sample's name as a string}
end;

end.
 