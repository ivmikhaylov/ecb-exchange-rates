package beReader

import (
	"errors"
	"fmt"
)

const (
	usrName       = "reader"
	pwdFile       = "go-password-reader"
	msg500        = "ecbrates: internal server error"
	msgEmpty      = "ecbrates: empty response"
	msgNotValid   = "ecbrates: not valid"
	msgNoRates    = "ecbrates: no rates"
	dfltHtmlTitle = "Here you are"
	dateTinyFmt   = "20060102"
	dateFmt       = "2006-01-02"
)

var (
	msgNoRatesJson = fmt.Sprintf("[%q]", msgNoRates)
	err500         = errors.New(msg500)
	errEmpty       = errors.New(msgEmpty)
	errNotValid    = errors.New(msgNotValid)
	errNoRates     = errors.New(msgNoRates)
)
