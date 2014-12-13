unit _fQueryResult;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  Grids, DBGrids;

type

  { TfQueryResult }

  TfQueryResult = class(TForm)
    ds_Result: TDatasource;
    gr_Result: TDBGrid;
    sql_Result: TSQLQuery;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure SetSQL(ASQL: String);
  end;

implementation

{$R *.lfm}

{ TfQueryResult }

procedure TfQueryResult.FormShow(Sender: TObject);
var
  i: Integer;
begin
  try
    sql_Result.Open;
  except
    ShowMessage('Запрос был выполнен с ошибкой!');
  end;

  Self.Width := 0;

  for i := 0 to gr_Result.Columns.Count - 1 do
  begin
    Self.Width := Self.Width + gr_Result.Columns[i].Width;
  end;

  Self.Width := Self.Width + 100;
end;

procedure TfQueryResult.SetSQL(ASQL: String);
begin
  sql_Result.SQL.Text := ASQL;
end;

end.

