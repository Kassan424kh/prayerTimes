import json
from flask import Flask, render_template, Response, request, make_response
from flask_restful import Resource, Api, reqparse
from datetime import datetime as dt, timedelta as td, date as d
from flask_cors import CORS
from urllib.request import urlopen, Request

app = Flask(__name__)
api = Api(app)
CORS(app)

with open('./translate.json', "r", encoding="utf8") as data:
    TRANSLATED_PRAYER_NAMES = json.load(data)

def cleanTimeText(prayer_value):
    return prayer_value[:5] + ":00Z"

end_times_of_prayers = {
    "Fajr": "Sunrise",
    "Sunrise": "Dhuhr",
    "Dhuhr": "Asr",
    "Asr": "Maghrib",
    "Maghrib": "Isha",
    "Isha": "Midnight"
}

# dart dateTime format => 2019-08-15 03:19:00Z"


def timesConverterToDartDateTimeFormat(lat, lng, language, only_today):

    json_data = {}

    # get the dataset
    url = f"http://api.aladhan.com/v1/calendar?latitude={lat}&longitude={lng}"
    response = urlopen(Request(url, headers={'User-Agent': 'Mozilla/5.0'}))

    # convert bytes to string type and string type to dict
    string = response.read().decode('utf-8')
    json_obj = json.loads(string)

    today = d.today()
    # YY-mm-dd
    today_date = today.strftime("%Y-%m-%d")

    # get all data objects from the json request
    for data in json_obj.get("data"):

        # convert date to german format and set it in date_of_this_object var to get it easy
        date_of_this_object = dt.strptime(data.get("date").get(
            "gregorian").get("date"), '%d-%m-%Y').strftime('%Y-%m-%d')

        prayer_times_of_this_date = []

        # get all prayerKeys and prayerValues from timings from the api request
        for prayer_key, prayer_value in data.get("timings").items():

            if language is None:
                language = "english"
            selectedTranslatingLanguage = TRANSLATED_PRAYER_NAMES[language]

            # check if key in arabic keys
            if prayer_key in selectedTranslatingLanguage:

                # start date of prayer
                start_date = (date_of_this_object + " " +
                              cleanTimeText(prayer_value))

                # end date of prayer
                end_date = (date_of_this_object + " " + cleanTimeText(data.get("timings").get(
                    end_times_of_prayers.get(prayer_key))))
                if prayer_key == "Isha":
                    end_date = ((dt.strptime(date_of_this_object, '%Y-%m-%d') + td(days=1)).strftime('%Y-%m-%d') + " " + cleanTimeText(
                                data.get("timings").get(end_times_of_prayers.get(prayer_key))))

                prayer_times_of_this_date.append({selectedTranslatingLanguage[prayer_key]:
                                                    [
                                                        start_date,
                                                        end_date
                                                    ]
                }
                )

        # set prayertimes to json_data var to returned it back as api
        json_data[date_of_this_object] = prayer_times_of_this_date

    if only_today is not None:
        json_data = json_data.get(today_date)
        pass

    return json_data


class GebetsZeiten(Resource):

    parser = reqparse.RequestParser()
    parser.add_argument('lat', required=True)
    parser.add_argument('lng', required=True)
    parser.add_argument('language', required=False)
    parser.add_argument('today', required=False)

    def get(self):
        args = self.parser.parse_args()
        return timesConverterToDartDateTimeFormat(args.get('lat', False), args.get('lng', False), args.get('language', None), args.get('today', None))

api.add_resource(GebetsZeiten, "/")


class PrivacyPolicy(Resource):
    def __init__(self):
        pass
    def get(self):
        headers = {'Content-Type': 'text/html'}
        return make_response(render_template('privacy_policy.html', title='Home', user='user'), 200, headers)

api.add_resource(PrivacyPolicy, "/privacy-policy")

class TermsAndConditions(Resource):
    def __init__(self):
        pass
    def get(self):
        headers = {'Content-Type': 'text/html'}
        return make_response(render_template('terms_and_conditions.html', title='Home', user='user'), 200, headers)

api.add_resource(TermsAndConditions, "/terms-and-conditions")

if __name__ == '__main__':
    app.run(port=5000, host="0.0.0.0")
