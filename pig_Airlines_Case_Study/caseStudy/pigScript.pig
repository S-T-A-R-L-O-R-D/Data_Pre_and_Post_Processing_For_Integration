data = load 'Airlines_Data.csv' using PigStorage(',');

grouped = group data by ($1);

totalFlightsPerMonth = FOREACH grouped GENERATE group,COUNT(data);

delayed = FILTER data by ($6-$7)>15;

delayedGrouped = GROUP delayed BY($1);

delayedCount = FOREACH delayedGrouped GENERATE group,COUNT(delayed);

joined = JOIN totalFlightsPerMonth by group, delayedCount by group;

proportion = FOREACH joined GENERATE $0 as month ,(float)$3/(float)$1 as ratio;

dump proportion;
