--cómo comparar las horas aportadas de cada voluntario con las horas  aportadas en promedio pero de forma acumulativa dentro de cada tarea?
SELECT id_tarea, nro_voluntario, horas_aportadas, avg(horas_aportadas)OVER w
FROM unc_esq_voluntario.voluntario
window w as (PARTITION BY id_tarea order by horas_aportadas);

--dentro de cada tarea cómo es el ranking de horas aportadas de cada voluntario?
SELECT id_tarea, nro_voluntario, horas_aportadas, rank() OVER w
FROM unc_esq_voluntario.voluntario
WINDOW w as (PARTITION BY id_tarea
ORDER BY horas_aportadas DESC);


