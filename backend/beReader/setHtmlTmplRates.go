package beReader

const (
	HtmlTmplRates = `
		<!DOCTYPE html>
		<html>
		    <head>
		        <style>

		            .divTable{
			            display: table;
			            width: 80%;
		            }

			         .divTableRow {
			            display: table-row;
		            }

		            .divTableHeading {
			            background-color: #EEE;
			            display: table-header-group;
		            }

		            .divTableCell, 
		            .divTableHead {
			            border: 1px solid #999999;
			            display: table-cell;
			            padding: 3px 10px;
		            }

		            .divTableHeading {
			            background-color: #EEE;
			            display: table-header-group;
			            font-weight: bold;
		            }

		            .divTableFoot {
			            background-color: #EEE;
			            display: table-footer-group;
			            font-weight: bold;
		            }

			        .divTableBody {
			            display: table-row-group;
		            }

		        </style>
		    </head>
		    <body>
		        <div class="divTable">
		            <div class="divTableHeading">
		                <div class="divTableRow">
		                    <div class="divTableHead">Currency name</div>
		                    <div class="divTableHead">Alphabetic code</div>
		                    <div class="divTableHead">Numeric code</div>
		                    <div class="divTableHead">Calendar date</div>
		                    <div class="divTableHead">Morning rate</div>
		                    <div class="divTableHead">Evening rate</div>
		                    <div class="divTableHead">Latest rate</div>
		                </div>
		            </div>
		            <div class="divTableBody">
		                {{ range .}}
		                <div class="divTableRow">
		                    <div class="divTableCell">{{ .CURRENCY_NAME   }}</div>
		                    <div class="divTableCell">{{ .ALPHABETIC_CODE }}</div>
		                    <div class="divTableCell">{{ .NUMERIC_CODE    }}</div>
		                    <div class="divTableCell">{{ .CALENDAR_DATE   }}</div>
		                    <div class="divTableCell">{{ .MORNING_RATE    }}</div>
		                    <div class="divTableCell">{{ .EVENING_RATE    }}</div>
		                    <div class="divTableCell">{{ .LATEST_RATE     }}</div>
		                </div>
		                {{ end}}
		            </div>
		        </div>
		    </body>
		</html>`
)
