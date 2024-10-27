function plotPowerSpectrum(timeSeries)

fs = 8760;

timeSeries_mean = timeSeries - mean(timeSeries);

[pxx,f] = periodogram(timeSeries_mean,[],[],fs);

plot(1./f,pxx)
xlim([0,5])
xlabel('period')
ylabel('Magnitude')
end
