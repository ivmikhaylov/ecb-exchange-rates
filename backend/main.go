package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gorilla/handlers"
	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beAdmin"
	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beReader"
	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beWriter"
)

func main() {
	finish := make(chan bool)

	reader8000 := http.NewServeMux()
	reader8000.HandleFunc("/", beReader.HandleReaderHtml)
	reader8000.HandleFunc("/index.html", beReader.HandleReaderHtml)
	reader8000.HandleFunc("/actual_rates.html", beReader.HandleReaderActualHtml)
	reader8000.HandleFunc("/actual_rates.json", beReader.HandleReaderActualJson)
	reader8000.HandleFunc("/historical_rates.html", beReader.HandleReaderHistoricalHtml)
	reader8000.HandleFunc("/historical_rates.json", beReader.HandleReaderHistoricalJson)

	writer8001 := http.NewServeMux()
	writer8001.HandleFunc("/", beWriter.HandleWriterHtml)
	writer8001.HandleFunc("/index.html", beWriter.HandleWriterHtml)
	writer8001.HandleFunc("/add_date.html", beWriter.HandleWriterAddDateHtml)
	writer8001.HandleFunc("/add_date.json", beWriter.HandleWriterAddDateJson)
	writer8001.HandleFunc("/add_rss.html", beWriter.HandleWriterAddRssHtml)
	writer8001.HandleFunc("/add_rss.json", beWriter.HandleWriterAddRssJson)
	writer8001.HandleFunc("/fill_gaps.html", beWriter.HandleWriterFeelGapsHtml)
	writer8001.HandleFunc("/fill_gaps.json", beWriter.HandleWriterFeelGapsJson)
	writer8001.HandleFunc("/missing_dates.html", beWriter.HandleWriterGetMissingHtml)
	writer8001.HandleFunc("/missing_dates.json", beWriter.HandleWriterGetMissingJson)
	writer8001.HandleFunc("/lock.html", beWriter.HandleWriterLockHtml)
	writer8001.HandleFunc("/lock.json", beWriter.HandleWriterLockJson)
	writer8001.HandleFunc("/unlock.html", beWriter.HandleWriterUnLockHtml)
	writer8001.HandleFunc("/unlock.json", beWriter.HandleWriterUnLockJson)

	admin8002 := http.NewServeMux()
	admin8002.HandleFunc("/", beAdmin.HandleAdminHtml)
	admin8002.HandleFunc("/index.html", beAdmin.HandleAdminHtml)

	// For compatibility with previous version:
	reader8000.HandleFunc("/actual_rates/", beReader.HandleReaderActualHtml)
	reader8000.HandleFunc("/historic_rates/", beReader.HandleReaderHistoricalHtml)
	writer8001.HandleFunc("/add_date/", beWriter.HandleWriterAddDateHtml)
	writer8001.HandleFunc("/add_rss/", beWriter.HandleWriterAddRssHtml)
	writer8001.HandleFunc("/fill_gaps/", beWriter.HandleWriterFeelGapsHtml)
	writer8001.HandleFunc("/missing_dates/", beWriter.HandleWriterGetMissingHtml)
	writer8001.HandleFunc("/pause/", beWriter.HandleWriterLockHtml)
	writer8001.HandleFunc("/unpause/", beWriter.HandleWriterUnLockHtml)

	go func() {
		http.ListenAndServe(":8000", reader8000)
		log.Print(http.ListenAndServe(":8000", handlers.LoggingHandler(os.Stdout, reader8000)))
	}()

	go func() {
		http.ListenAndServe(":8001", writer8001)
		log.Print(http.ListenAndServe(":8001", handlers.LoggingHandler(os.Stdout, writer8001)))
	}()

	go func() {
		http.ListenAndServe(":8002", admin8002)
		log.Print(http.ListenAndServe(":8002", handlers.LoggingHandler(os.Stdout, admin8002)))
	}()

	<-finish
}
