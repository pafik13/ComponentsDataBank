unit miCL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, menus;

type

  { TMenuItemCL }

  TMenuItemCL = class(TMenuItem)
  protected
    FSubPath: String;
    FPath   : String;
  private
    function GetSubPath: String;
    function GetPath   : String;
    procedure SetSubPath (const AValue: String);
    procedure SetPath (const AValue: String);
  public
    property SubPath: String read GetSubPath write SetSubPath;
    property Path: String read GetPath write SetPath;
  end;

implementation

{ TMenuItemCL }

function TMenuItemCL.GetSubPath: String;
begin
  Result := FSubPath;
end;

function TMenuItemCL.GetPath: String;
begin
  Result := FPath;
end;

procedure TMenuItemCL.SetSubPath(const AValue: String);
begin
  FSubPath:= AValue;
end;

procedure TMenuItemCL.SetPath(const AValue: String);
begin
  FPath:= AValue;
end;

end.

