import lxml.html as lh
import requests as r
import pandas as pd
import subprocess
import json
import os.path as op
import os

from pathlib import Path as path
from flask import Flask, render_template, Response, request
from flask_restful import Resource, Api
from datetime import datetime as dt, timedelta as td, date as d
from flask_cors import CORS

app = Flask('__main__')
api = Api(app)
CORS(app)

prayer_times_folder_location = 'prayer_times_data/'

def getActivePrayer(prayer_times):
    pt_index = 0
    for pts in prayer_times:
        for pts_key in list(pts):
            start = dt.strptime(pts[pts_key][0], '%Y-%m-%d %H:%M:%SZ')
            end = dt.strptime(pts[pts_key][1], '%Y-%m-%d %H:%M:%SZ')
            datetime_now = dt.strptime(dt.strftime(
                dt.now(), '%Y-%m-%d %H:%M:%SZ'), '%Y-%m-%d %H:%M:%SZ')
            if start < datetime_now and end >= datetime_now:
                prayer_times[pt_index]["active"] = True
            else:
                prayer_times[pt_index]["active"] = False
        pt_index += 1

def getData():
    prayer_times = []
    prayer_times_file_name = prayer_times_folder_location + \
        str(dt.now())[0:10] + '.json'
    prayer_times_from_json_file = path(prayer_times_file_name)
    if prayer_times_from_json_file.is_file():
        print('[Important] Prayer times is from file imported')
        with open(prayer_times_file_name, 'r') as ptf:
            prayer_times = json.load(ptf)
    else:
        print('[Important] Prayer times is from url/server imported')
        url = 'https://www.gebetszeiten.de/Harburg/gebetszeiten-Buchholz-in-der-Nordheide/161069-dit17de#'
        page = r.get(url)
        doc = lh.fromstring(page.content)
        prayerTime = doc.xpath(
            '//div[contains(concat(" ", @class, " "), " prayerTime ")]')
        gebets_zeiten_namen = ['الفجر', 'الشروق',
                               'الضهر', 'العصر', 'المفرب', 'العشاء', ]

        gebets_zeiten = []
        for index, prayer_times_from_array in enumerate(prayerTime):
            if index == 0:  # first prayer
                g_zeit_start = str(dt.now())[
                    0:11] + prayer_times_from_array.text_content().strip()[0:5] + ':00Z'
                g_zeit_end = str(dt.now())[
                    0:11] + prayerTime[index + 1].text_content().strip()[0:5] + ':00Z'
            elif index == len(prayerTime) - 1:  # last prayer
                g_zeit_start = str(dt.now())[
                    0:11] + prayer_times_from_array.text_content().strip()[68:73] + ':00Z'
                g_zeit_end = str(dt.now() + td(days=1))[0:11] + " ".join(
                    prayer_times_from_array.text_content().split())[39:44] + ':00Z'
            else:  # other prayer
                g_zeit_start = str(dt.now())[
                    0:11] + prayer_times_from_array.text_content().strip() + ':00Z'
                if index == len(prayerTime) - 2:
                    g_zeit_end = str(dt.now())[
                        0:11] + prayerTime[index + 1].text_content().strip()[68:73] + ':00Z'
                else:
                    g_zeit_end = str(dt.now())[
                        0:11] + prayerTime[index + 1].text_content().strip() + ':00Z'
            gebets_zeiten.append(
                {gebets_zeiten_namen[index]: [g_zeit_start, g_zeit_end]})

        with open(prayer_times_file_name, 'w') as ptf:
            json.dump(gebets_zeiten, ptf, )

        old_prayer_times_json_file_name = prayer_times_folder_location + \
            str(dt.now() - td(days=1))[0:10] + '.json'
        old_prayer_times_json_file = path.open(old_prayer_times_json_file_name)
        if old_prayer_times_json_file.is_file():
            os.remove(old_prayer_times_json_file_name)

    getActivePrayer(prayer_times)
    
    return prayer_times

class GebetsZeiten(Resource):
    def get(self):
        return getData()


api.add_resource(GebetsZeiten, "/")

if __name__ == '__main__':
    app.run(port=5000, host="0.0.0.0")
