package beUtils

const (
	HtmlTemplateStatus = `
		<!DOCTYPE html>
		<html>
		    <head>
		        <style>

		            .divTable{
			            display: table;
			            width: 40%;
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
		                    <div class="divTableHead">Status response</div>
		                </div>
		            </div>
		            <div class="divTableBody">
		                <div class="divTableRow">
		                    <div class="divTableCell">{{ . }}</div>
		                </div>
		            </div>
		        </div>
		    </body>
		</html>`
)
