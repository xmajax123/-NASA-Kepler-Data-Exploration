# Comparin mean and median of crucial parameters
select koi_disposition,
count(*) as numbers_of_objects,

round(avg(koi_model_snr),3) as SNR_mean,
approx_quantiles(koi_model_snr,2)[offset(1)] as SNR_median,

round(avg(koi_prad),3) as planet_size_R_earth,
approx_quantiles(koi_prad,2)[offset(1)] as planet_size_median,

approx_quantiles(koi_insol,2)[offset(1)] as insolation_median,
round(avg(koi_insol),3) as insolation_mean,


approx_quantiles(koi_steff,2)[offset(1)] as temperature_median,
round(avg(koi_steff),3) as temp_mean

from `keppler-497213.Keppler_data.raw_keppler_data`
group by koi_disposition;


# Checking correlation
select 

corr(koi_model_snr, koi_prad) as kor_snr_rozmiar,
corr(koi_insol,koi_prad) as insol_prad,
corr(koi_slogg, koi_prad) as wielkosc_grawitacja

from `keppler-497213.Keppler_data.raw_keppler_data`;

# Top 10 Planets with the Strongest Signal (SNR)

select kepler_name as `Name` ,koi_model_snr as `SNR`, koi_prad as `Size of planet`, koi_steff as `Star temperature K`, koi_insol as `Insolation Flux`, koi_teq as `Planet temperature`, koi_disposition as `Status`
from `keppler-497213.Keppler_data.raw_keppler_data`
where koi_disposition = 'CONFIRMED'
order by koi_model_snr desc
limit 10;

# Star classification success rate
select 
case
  when koi_steff between 5200 and 6000 then "Yellow dwarf"
  when koi_steff between 3500 and 5200 then  "Orange dwarf"
  when koi_steff <= 3500 then "Red dwarf"
  else  "Unkown"
end as `Star clasification`,
count(*) as `All results`,
countif(koi_disposition= "CONFIRMED") as `Confirmed planet` 

from `keppler-497213.Keppler_data.raw_keppler_data`

group by 1 
order by 1 desc;
# Comparing single SNR with star group mean

with Imp_classification as (

select kepid, kepler_name, koi_disposition, koi_model_snr,
case
  when koi_steff between 5200 and 6000 then "Yellow dwarf"
  when koi_steff between 3500 and 5200 then  "Orange dwarf"
  when koi_steff <= 3500 then "Red dwarf"
  else  "Unkown"
end as `Star clasification`
from `keppler-497213.Keppler_data.raw_keppler_data`

),

ranking_raport as(

  select 
  kepler_name,
  `Star clasification`,
  koi_model_snr  as `SNR`,
  rank() over (partition by `Star clasification` order by koi_model_snr desc) as planetary_rank,
  round(avg(koi_model_snr) over(partition by `Star clasification`),2) as `Average SNR`
  from Imp_classification
  where koi_disposition = "CONFIRMED"

)

SELECT * from ranking_raport
where planetary_rank <= 20
order by `Star clasification` asc;

# Correlatio between SNR and other parameters
select  
corr (koi_model_snr, koi_steff) as `Correlation between SNR and star temperature`,
corr (koi_model_snr, koi_depth) as `Correlation between SNR and transit depth`,
corr (koi_model_snr, koi_prad) as `Correlation between SNR and planet size`,
corr (koi_model_snr, koi_srad) as `Correlation between SNR and star  size`,
corr (koi_model_snr, koi_period) as `Correlation between SNR and planet period`
from  `keppler-497213.Keppler_data.raw_keppler_data`;

# Corelation between  SNR and transit depth for different stars

with Imp_classification as (

select kepid, kepler_name, koi_disposition, koi_model_snr,koi_depth,
case
  when koi_steff between 5200 and 6000 then "Yellow dwarf"
  when koi_steff between 3500 and 5200 then  "Orange dwarf"
  when koi_steff <= 3500 then "Red karzeł"
  else  "Unkown"
end as `Star clasification`
from `keppler-497213.Keppler_data.raw_keppler_data`) 

select `Star clasification`,
corr(koi_model_snr, koi_depth) as `Correlation between SNR and transit depth for Yellow`
from Imp_classification
group by `Star Clasification`;
 #  Common mistakes 
 select koi_disposition, 
 concat(round(sum(koi_fpflag_nt)/count(*)*100,2), "%") as `Not-transit like flag`, 
 concat(round(sum(koi_fpflag_ss)/count(*) *100,2), "%") as `Stellar Eclipse Flag`, 
 concat(round(sum(koi_fpflag_co)/ count(*)*100,2), "%") as `Centroid Offset Flag`,
 concat(round( sum(koi_fpflag_ec)/ count(*)*100,2), "%") as `Ephemeris Match Flag`
 from `keppler-497213.Keppler_data.raw_keppler_data`
 group by koi_disposition
