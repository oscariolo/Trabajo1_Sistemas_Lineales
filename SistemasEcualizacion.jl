### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 3e4f8449-dcf3-4f5a-932f-0561d6e17001
begin
	using Pkg
	Pkg.add("FFTW")
	Pkg.add("WAV")
end

# ╔═╡ a0eb3a20-7b4e-11ee-34b8-31a5224d00b3
begin
	using FFTW
	using WAV
	using Plots
end

# ╔═╡ 49ea059c-917c-4f23-9024-751b1a4d3e50
begin
	audioStereo, fs = wavread("./audiodeprueba.wav") #carga el archivo de audio con 2 canales
	audioMono = (audioStereo[:,1] + audioStereo[:,2])/2 #combinamos los canales en 1 canal de audio
	audioEspectro = fftshift(fft(audioMono)) #obtenemos el espectro de audio con la Transformada rápida de Fourier 
	f = abs.(range(-fs/2, fs/2, length = length(audioMono))) #definimos un vector de impulsos del tamaño de la frecuencia del rango original
end

# ╔═╡ cab6ddb4-3c3f-41c0-b276-a9167bf913d7
plot(audioMono, label="Señal original")

# ╔═╡ a31dca66-923d-4484-b1f1-30dd134e6466
function lpfFilter(f) #funcion para aplicar el Low Pass Filter
	if(f<=500)
		return true
	end
	return false
end

# ╔═╡ 3b4efe16-5c2a-4cc5-9465-a86658451886
begin
	lpf = lpfFilter.(f) #se obtiene el filtro del rango de frecuencias
	espectro_lpf = audioEspectro .* lpf #se filtra con el uso de convolución
end

# ╔═╡ 723a651b-e634-46ab-b7ca-49e0519dd232
scatter(lpf, xlims=(98000, 105000), title="Filtro LPF", label=false)

# ╔═╡ 1d8eaebd-d327-4b7f-b020-b609b7b00231
begin
	filtrado_lpf = real.(ifft(ifftshift(espectro_lpf))) #se vuelve al dominio de tiempo con la transformada inversa
	wavwrite(real.(filtrado_lpf), "Filtrado lpf.wav", Fs=fs) #se guarda el archivo de audio
end

# ╔═╡ 71b84cdf-7252-4e00-82e7-7754c1c3ad96
begin
	plot(audioMono, label="Señal original")
	plot!(filtrado_lpf, label="Señal filtrado LPF")
end

# ╔═╡ 22cca9ef-e19c-4fe5-a79f-5b89e23193d9
function hpfFilter(f) #funcion para aplicar el High Pass Filter
	if(f>=500)
		return true
	end
	return false
end

# ╔═╡ 77d183b1-d747-4166-afa3-6f72f529d7ba
begin
	hpf = hpfFilter.(f) #se obtiene el filtro del rango de frecuencias
	espectro_hpf = audioEspectro .* hpf #se filtra con el uso de convolución
end

# ╔═╡ 563b871b-dfaa-466d-b09c-2d0c4080285f
scatter(hpf, xlims=(98000, 105000), title="Filtro HPF", label=false)

# ╔═╡ e855eca8-d358-45f0-bb18-d8036078f88d
begin
	filtrado_hpf = real.(ifft(ifftshift(espectro_hpf))) #se vuelve al dominio de tiempo con la transformada inversa
	wavwrite(real.(filtrado_hpf), "Filtrado lpf.wav", Fs=fs) #se guarda el archivo de audio
end

# ╔═╡ 183a87af-8ea7-44be-9dd6-4676eaf2a654
begin
	plot(audioMono, label="Señal original")
	plot!(filtrado_hpf, label="Señal filtrado HPF")
end

# ╔═╡ f4621f2e-8756-449b-9ab1-37acd44dbc6f
#plot(soundfreq,abs2.(soundhat)/n,ylim=(0,200),label="PSD Señal Original")

# ╔═╡ 4c124a1d-639e-480a-848f-45726e427cc1
#plot(soundfreq,abs2.(soundfilthat)/n,label="PSD Señal Filtrada")

# ╔═╡ a0ba3c71-08eb-4629-8a15-c06af2466794
#=begin
	soundfilt=real.(ifft(soundfilthat))
	plot(sound, xlim=(20000,22000), label="Señal original")
	plot!(soundfilt, label="Señal filtrado")
end=#

# ╔═╡ Cell order:
# ╠═3e4f8449-dcf3-4f5a-932f-0561d6e17001
# ╠═a0eb3a20-7b4e-11ee-34b8-31a5224d00b3
# ╠═49ea059c-917c-4f23-9024-751b1a4d3e50
# ╠═cab6ddb4-3c3f-41c0-b276-a9167bf913d7
# ╠═a31dca66-923d-4484-b1f1-30dd134e6466
# ╠═3b4efe16-5c2a-4cc5-9465-a86658451886
# ╠═723a651b-e634-46ab-b7ca-49e0519dd232
# ╠═1d8eaebd-d327-4b7f-b020-b609b7b00231
# ╠═71b84cdf-7252-4e00-82e7-7754c1c3ad96
# ╠═22cca9ef-e19c-4fe5-a79f-5b89e23193d9
# ╠═77d183b1-d747-4166-afa3-6f72f529d7ba
# ╠═563b871b-dfaa-466d-b09c-2d0c4080285f
# ╠═e855eca8-d358-45f0-bb18-d8036078f88d
# ╠═183a87af-8ea7-44be-9dd6-4676eaf2a654
# ╠═f4621f2e-8756-449b-9ab1-37acd44dbc6f
# ╠═4c124a1d-639e-480a-848f-45726e427cc1
# ╠═a0ba3c71-08eb-4629-8a15-c06af2466794
