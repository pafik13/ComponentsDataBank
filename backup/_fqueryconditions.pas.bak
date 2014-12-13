unit _fQueryConditions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, maskedit, StdCtrls, _fQueryResult;

type

  { TfQueryConditions }

  TfQueryConditions = class(TForm)
    Button1: TButton;
    sql_ColumnInfo: TSQLQuery;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    FStoreTable: String;
    function GenerateSQL(): String;
  public
    { public declarations }
    procedure SetStoreTable(AStoreTable: String);
  end;

const
  CLRF: array[0..1] of char = #13#10;
  TAB: char = #9;

implementation

{$R *.lfm}

{ TfQueryConditions }

procedure TfQueryConditions.FormShow(Sender: TObject);
var
  i: Integer;
  ed: TLabeledEdit;
begin
  with sql_ColumnInfo do
  begin
    SQL.Add('SELECT * FROM get_columns_info(''' + FStoreTable + ''')');
    Open;

    for i := 1 to RecordCount do
    begin
      ed := TLabeledEdit.Create(Self);
      ed.Top := i * 40 + 16;
      ed.Left := 100;
      ed.Height := 24;
      ed.Width:= 150;
      ed.EditLabel.Height:= 13;
      ed.Visible:= True;
      ed.Parent:=Self;
      ed.EditLabel.Caption := FieldByName('cmt').Text;
      ed.Text := FieldByName('col').Text;
      ed.Name := FieldByName('col').Text;

      { DataTypes [Start] }
      if FieldByName('typ').Text = 'string' then ed.Tag := 0;
      if FieldByName('typ').Text = 'integer' then ed.Tag := 1;
      { DataTypes [-End-] }
      Next;
    end;
  end;
end;

function TfQueryConditions.GenerateSQL: String;
var
  selCond, fromCond, whereCond: String;
  i: Integer;
  le: TLabeledEdit;
begin
  selCond := 'SELECT ' + CLRF;

  with sql_ColumnInfo do
  begin
    First;
    for i := 1 to RecordCount do
    begin
      if RecNo = RecordCount then
        selCond := selCond + FieldByName('col').Text
                 + ' AS "' + FieldByName('cmt').Text + '"' + CLRF
      else
        selCond := selCond + FieldByName('col').Text
                 + ' AS "' + FieldByName('cmt').Text + '",' + CLRF;
      Next;
    end;
  end;

  fromCond := 'FROM ' +  FStoreTable + CLRF;

  whereCond:= 'WHERE 1=1' + CLRF;

  for i := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[i] is TLabeledEdit then
    begin
      le := TLabeledEdit(Self.Components[i]);

      if le.Text = ''
      then Continue
      else begin
        if le.Tag = 0 then
          whereCond := whereCond + 'AND ' + le.Name + ' = "' + le.Text + '"' + CLRF;
        if le.Tag = 1 then
          whereCond := whereCond + 'AND ' + le.Name + ' = ' + le.Text + CLRF;
      end;
    end;
  end;

  Result := selCond + fromCond + whereCond;
end;

procedure TfQueryConditions.Button1Click(Sender: TObject);
var
  SQL: String;
  fQR: TfQueryResult;
begin
  SQL := GenerateSQL;
  //ShowMessage(SQL);

  //InputBox('Caption','Prompt',SQL);

  fQR := TfQueryResult.Create(Self);
  fQR.SetSQL(SQL);
  fQR.Show;
end;

procedure TfQueryConditions.SetStoreTable(AStoreTable: String);
begin
  FStoreTable := AStoreTable;
end;

end.

