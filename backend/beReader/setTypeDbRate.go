package beReader

type DbSingleRate struct {
	CURRENCY_NAME   string
	ALPHABETIC_CODE string
	NUMERIC_CODE    string
	CALENDAR_DATE   string
	MORNING_RATE    string
	EVENING_RATE    string
	LATEST_RATE     string
}

type DbManyRates []DbSingleRate
