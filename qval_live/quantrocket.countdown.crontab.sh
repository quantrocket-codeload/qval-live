# Crontab commands for qval-live
# Intended to be run in timezone America/New_York

# Crontab syntax cheat sheet
# .------------ minute (0 - 59)
# |   .---------- hour (0 - 23)
# |   |   .-------- day of month (1 - 31)
# |   |   |   .------ month (1 - 12) OR jan,feb,mar,apr ...
# |   |   |   |   .---- day of week (0 - 6) (Sunday=0 or 7)  OR sun,mon,tue,wed,thu,fri,sat
# |   |   |   |   |
# *   *   *   *   *   command to be executed

# Collect Sharadar fundamentals overnight 
0 3 * * * mon-fri quantrocket fundamental collect-sharadar  

# make sure IB Gateway is running each weekday
0 8 * * mon-fri quantrocket launchpad start

# collect NYSE trading hours each morning (provides trading hours for the next month)
30 8 * * mon-fri quantrocket master collect-calendar -e 'NYSE'

# Trade qval-live on the first day of the quarter. This command "paper trades" qval-live by logging orders to flightlog; to 
# live or paper trade with IB, send orders to blotter instead:
#     ... quantrocket moonshot trade 'qval-live' | quantrocket blotter order -f -
0 9 * * mon-fri quantrocket master isopen 'NYSE' --in 1h && quantrocket master isclosed 'NYSE' --since 'Q' && quantrocket moonshot trade 'qval-live' | quantrocket flightlog log -n 'quantrocket.moonshot'

# Collect IB history if market was open
0 17 * * mon-fri quantrocket master isopen 'NYSE' --ago 6h && quantrocket history collect 'nyse-stk-1d' --priority

# Maintain NYSE universe by delisting missing/delisted symbols
0 21 * * mon-fri quantrocket master diff -u 'nyse-stk' --fields 'ConId' --delist-missing --delist-exchanges 'VALUE'
