unit _fHelp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  pqconnection;

type

  { TfHelp }

  TfHelp = class(TForm)
    SQLQuery: TSQLQuery;
    StringGrid1: TStringGrid;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    PQConnection: TPQConnection;
  public
    { public declarations }
    procedure SetConnetcion(APQConnection: TPQConnection);
  end;

implementation

{$R *.lfm}

{ TfHelp }

procedure TfHelp.FormShow(Sender: TObject);
var
  c, r: Integer;
begin
  with SQLQuery do
  begin
    Active:= True;
    StringGrid1.RowCount := RecordCount + 1;
    StringGrid1.ColCount := FieldCount + 1;
    StringGrid1.FixedCols:=1;
    StringGrid1.FixedRows:=1;

    for c := 1 to Fields.Count do
      StringGrid1.Cells[c,0] := Fields[c-1].FieldName;

    while not EOF do
    begin
      for c := 1 to Fields.Count do
        StringGrid1.Cells[c, RecNo] := Fields[c-1].Value;
      Next;
    end;
  end;
end;

procedure TfHelp.SetConnetcion(APQConnection: TPQConnection);
begin
  PQConnection := APQConnection;
end;

end.

