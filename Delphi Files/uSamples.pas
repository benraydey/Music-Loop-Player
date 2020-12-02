unit uSamples;

interface

uses SysUtils;

{Samples class defines a samples object
 that contains all the data related to a sample}

type TSamples = class
  private
    SampleID,
    Bars : Integer;
    Tempo : Real;
    SampleName,
    FileName,
    Instrument : String;
    Favourite : String;
  public
    Constructor Create (id : integer; te : real; ba : integer; na, fa, fi, inst : string);  {Instantiates object. Takes in id, tempo, bar length, name, favourites value, filename and instrument as parameters}
    function getSampleID : Integer;       {Returns the sample's ID as an integer}
    function getTempo : Real;             {Returns the sample's tempo as a real}
    function getSampleName : String;      {Returns the sample's name as a string}
    function getFavourite : String;       {Returns the sample's favourites value as a string}
    function getInstrument : String;      {Returns the sample's instrument as a string}
    function getFileName : String;        {Returns the sample's filename as a string}
    function getBars : Integer;           {Returns the sample's length in bars as an integer}
    procedure setFavourite (fa : string);   {Updates the sample's favourite's value}
    function toString : String;           {Returns the sample's name as a string}

end;

implementation

{ TSamples }

constructor TSamples.Create(id : integer; te : real; ba : integer; na, fa, fi, inst : string);
begin

  {Instantiates object. Takes in id, tempo, bar length, name, favourites value, filename and instrument as parameters}

  SampleID := id;
  Tempo := te;
  Bars := ba;
  SampleName := na;
  FileName := fi;
  Instrument := inst;
  Favourite := fa;
end;

function TSamples.getBars: Integer;
begin
  Result := Bars;         {Returns the sample's length in bars as an integer}
end;

function TSamples.getFavourite: String;
begin
  Result := Favourite;   {Returns the sample's favourites value as a string}
end;

function TSamples.getFileName: String;
begin
  Result := FileName;    {Returns the sample's filename as a string}
end;

function TSamples.getInstrument: String;
begin
  Result := Instrument;  {Returns the sample's instrument as a string}
end;

function TSamples.getSampleID: Integer;
begin
  Result := SampleID;    {Returns the sample's ID as an integer}
end;

function TSamples.getSampleName: String;
begin
  Result := SampleName;  {Returns the sample's name as a string}
end;

function TSamples.getTempo: Real;
begin
  Result := Tempo;       {Returns the sample's tempo as a real}
end;

procedure TSamples.setFavourite(fa: String);
begin
  Favourite := fa;       {Updates the sample's favourite's value}
end;

function TSamples.toString: String;
begin
  Result := SampleName;  {Returns the sample's name as a string}
end;

end.
 