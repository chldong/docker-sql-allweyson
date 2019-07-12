#!/bin/bash

# wait for MSSQL server to start
export STATUS=1
i=0

while [[ $STATUS -ne 0 ]] && [[ $i -lt 30 ]]; do
	i=$i+1
	/opt/mssql-tools/bin/sqlcmd -t 1 -U sa -P $MSSQL_SA_PASSWORD -Q "select 1" >> /dev/null
	STATUS=$?
done

if [ $STATUS -ne 0 ]; then 
	echo "Error: MSSQL SERVER took more than thirty seconds to start up."
	exit 1
fi

echo "======= MSSQL SERVER STARTED ========" 


sqlcmd -S db1.internal.portalsql.es -U SA -P 'PortalSQL01Demo#' -i 01_PrincipalServer.sql
sqlcmd -S db2.internal.portalsql.es -U SA -P 'PortalSQL01Demo#' -i 02_SecondaryServer.sql
sqlcmd -S db3.internal.portalsql.es -U SA -P 'PortalSQL01Demo#' -i 02_SecondaryServer.sql
sqlcmd -S db1.internal.portalsql.es -U SA -P 'PortalSQL01Demo#' -i 03_CreateAvailabilityGroup.sql
sqlcmd -S db2.internal.portalsql.es -U SA -P 'PortalSQL01Demo#' -i 04_JoinAvailabilityGroup.sql
sqlcmd -S db3.internal.portalsql.es -U SA -P 'PortalSQL01Demo#' -i 04_JoinAvailabilityGroup.sql
sqlcmd -S db1.internal.portalsql.es -U SA -P 'PortalSQL01Demo#' -i RestoreAdventureWorksDWandPutitAvailable.sql
