import json
import pandas as pd
import os

def jsontoexcel(dirpath):
    writer=pd.ExcelWriter('players.xlsx')
    for team in os.listdir(dirpath):
        df = pd.read_json(dirpath+team)
        df.to_json()
        df.to_excel(excel_writer=writer, sheet_name=team.split('.')[0],index=False)
    writer.save()


def exceltojson():
    xl = pd.ExcelFile('players.xlsx')
    for sheetname in xl.sheet_names:
        df = pd.read_excel(xl, engine='openpyxl', sheet_name=sheetname,dtype=str).fillna('')
        writeToFile(df.to_json(orient='records'), os.path.join('teams', sheetname + '.json'))


def formatBFF(bff: str):
    return bff.replace(')','').replace('(','/')



def validateAndModify(playersList):
    for player in playersList:
        player['bestBowlingFigure']=formatBFF(player['bestBowlingFigure'])
    return playersList


def writeToFile(data, fileName, openOption="w"):
  file = open(fileName, openOption)
  file.write(json.dumps(validateAndModify(json.loads(data)), indent=4))
  file.close()


# Press the green button in the gutter to run the script.
# Kolkata R Singh to be changed to bowler
# Rajasthan Yashasvi Jaiswal to be removed
if __name__ == '__main__':
   # jsontoexcel('./input/')
   exceltojson()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
