package beWriter

type SingleRate struct {
	PUB_DATETIME string
	CUR_CODE     string
	EVENING_RATE string
}

type ManyRates []SingleRate
