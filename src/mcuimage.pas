unit MCUImage;

{$mode ObjFPC}{$H+}{$J-}

interface

uses
  Classes, SysUtils, Graphics, Generics.Collections, StrUtils;

type
  TRepresentationType = (rtHex, rtBin);
  TArrayLayout        = (al1D, al2DHW, al2DWH);
  TDataType           = (dtUint8, dtUint16);

  { TMCUImage }

  TMCUImage = class
  private
    FPath:    string;
    FPicture: TPicture;
  public
    constructor Create(APath: string);
    destructor Destroy; override;

    property Path: string read FPath;
    property Picture: TPicture read FPicture;
  end;

  TMCUImageList = specialize TObjectList<TMCUImage>;

function RGBValuesEqual(AColor1, AColor2: TColor): boolean;

function CanvasToStr(ABitmap: TBitmap;
  ARepresentationType: TRepresentationType; AArrayLayout: TArrayLayout;
  ADataType: TDataType): string;

implementation

function RGBValuesEqual(AColor1, AColor2: TColor): boolean;
const
  RGBMask = $00FFFFFF;
begin
  AColor1 := AColor1 and RGBMask;
  AColor2 := AColor2 and RGBMask;
  Result  := AColor1 = AColor2;
end;

function CanvasToStr(ABitmap: TBitmap;
  ARepresentationType: TRepresentationType; AArrayLayout: TArrayLayout;
  ADataType: TDataType): string;
var
  I, X, Y: integer;
  U8:      uint8;
  U16:     uint16;
begin
  { 2D array [height][width] }
  if AArrayLayout = al2DHW then
  begin
    Result := Format('const uint8_t frame[%d][%d] = {' + #10,
      [ABitmap.Height, ABitmap.Width]);
    for Y := 0 to Pred(ABitmap.Height) do
    begin
      Result += '  {';
      for X := 0 to Pred(ABitmap.Width) do
        if RGBValuesEqual(ABitmap.Canvas.Pixels[X, Y], TColor(0)) then
          Result += '0,'
        else
          Result += '1,';
      SetLength(Result, Length(Result) - 1);
      Result += '},' + #10;
    end;
    SetLength(Result, Length(Result) - 2);
    Result += '};';
  end

  { 2D array [width][height] }
  else if AArrayLayout = al2DWH then
  begin
    Result := Format('const uint8_t frame[%d][%d] = {' + #10,
      [ABitmap.Width, ABitmap.Height]);
    for X := 0 to Pred(ABitmap.Width) do
    begin
      Result += '  {';
      for Y := 0 to Pred(ABitmap.Height) do
        if RGBValuesEqual(ABitmap.Canvas.Pixels[X, Y], TColor(0)) then
          Result += '0,'
        else
          Result += '1,';
      SetLength(Result, Length(Result) - 1);
      Result += '},' + #10;
    end;
    SetLength(Result, Length(Result) - 2);
    Result += '};';
  end

  { binary 1D array of uint8 }
  else if (ARepresentationType = rtBin) and (AArrayLayout = al1D) and
    (ADataType = dtUint8) then
  begin
    Result := 'const uint8_t frame[] = {';
    U8     := 0;
    for I := 0 to Pred(ABitmap.Height * ABitmap.Width) do
    begin
      Y  := I div ABitmap.Width;
      X  := I mod ABitmap.Width;
      U8 := U8 shl 1;
      if not RGBValuesEqual(ABitmap.Canvas.Pixels[X, Y], TColor(0)) then
        U8 := U8 or 1;
      if (I mod 8 = 7) or (I = Pred(ABitmap.Height * ABitmap.Width)) then
      begin
        Result += '0b' + IntToBin(U8, 8) + ', ';
        U8     := 0;
      end;
    end;
    SetLength(Result, Length(Result) - 2);
    Result += '};';
  end

  { hexadecimal 1D array of uint8 }
  else if (ARepresentationType = rtHex) and (AArrayLayout = al1D) and
    (ADataType = dtUint8) then
  begin
    Result := 'const uint8_t frame[] = {';
    U8     := 0;
    for I := 0 to Pred(ABitmap.Height * ABitmap.Width) do
    begin
      Y  := I div ABitmap.Width;
      X  := I mod ABitmap.Width;
      U8 := U8 shl 1;
      if not RGBValuesEqual(ABitmap.Canvas.Pixels[X, Y], TColor(0)) then
        U8 := U8 or 1;
      if (I mod 8 = 7) or (I = Pred(ABitmap.Height * ABitmap.Width)) then
      begin
        Result += '0x' + IntToHex(U8, 2) + ', ';
        U8     := 0;
      end;
    end;
    SetLength(Result, Length(Result) - 2);
    Result += '};';
  end

  { binary 1D array of uint16 }
  else if (ARepresentationType = rtBin) and (AArrayLayout = al1D) and
    (ADataType = dtUint16) then
  begin
    Result := 'const uint16_t frame[] = {';
    U16    := 0;
    for I := 0 to Pred(ABitmap.Height * ABitmap.Width) do
    begin
      Y   := I div ABitmap.Width;
      X   := I mod ABitmap.Width;
      U16 := U16 shl 1;
      if not RGBValuesEqual(ABitmap.Canvas.Pixels[X, Y], TColor(0)) then
        U16 := U16 or 1;
      if (I mod 16 = 15) or (I = Pred(ABitmap.Height * ABitmap.Width)) then
      begin
        Result += '0b' + IntToBin(U16, 16) + ', ';
        U16    := 0;
      end;
    end;
    SetLength(Result, Length(Result) - 2);
    Result += '};';
  end

  { hexadecimal 1D array of uint16 }
  else if (ARepresentationType = rtHex) and (AArrayLayout = al1D) and
    (ADataType = dtUint16) then
  begin
    Result := 'const uint16_t frame[] = {';
    U16    := 0;
    for I := 0 to Pred(ABitmap.Height * ABitmap.Width) do
    begin
      Y   := I div ABitmap.Width;
      X   := I mod ABitmap.Width;
      U16 := U16 shl 1;
      if not RGBValuesEqual(ABitmap.Canvas.Pixels[X, Y], TColor(0)) then
        U16 := U16 or 1;
      if (I mod 16 = 15) or (I = Pred(ABitmap.Height * ABitmap.Width)) then
      begin
        Result += '0x' + IntToHex(U16, 4) + ', ';
        U16    := 0;
      end;
    end;
    SetLength(Result, Length(Result) - 2);
    Result += '};';
  end;
end;

{ TMCUImage }

constructor TMCUImage.Create(APath: string);
begin
  FPath    := APath;
  FPicture := TPicture.Create;
  FPicture.LoadFromFile(FPath);
end;

destructor TMCUImage.Destroy;
begin
  FreeAndNil(FPicture);
  inherited;
end;

end.
