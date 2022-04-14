package beUtils

import (
	"errors"
)

const (
	dbPort      = 3306
	dbName      = "ecb-rates-db"
	pwdPath     = "/run/secrets/"
	msg500      = "ecbrates: internal server error"
	msgEmpty    = "ecbrates: empty response"
	msgNoAct    = "ecbrates: no actual rates"
	msgNoHist   = "ecbrates: no historical rates"
	msgNotValid = "ecbrates: not valid"
	dateTinyFmt = "20060102"
	dateFmt     = "2006-01-02"
	dateTimeFmt = "2006-01-02 15:04:05"
	minDateStr  = "1999-01-04 16:00:00"
)

var (
	errEmpty    = errors.New(msgEmpty)
	errNotValid = errors.New(msgNotValid)
)
