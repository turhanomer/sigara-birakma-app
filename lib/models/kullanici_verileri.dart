class KullaniciVerileri {
  final int? id;
  final int kullaniciId;
  final DateTime birakisTarihi;
  final int gunlukIcilenSigara;
  final double paketFiyati;
  final int paketSigaraSayisi;

  KullaniciVerileri({
    this.id,
    required this.kullaniciId,
    required this.birakisTarihi,
    required this.gunlukIcilenSigara,
    required this.paketFiyati,
    required this.paketSigaraSayisi,
  });

  Map<String, dynamic> toMap() {
    return {
      'kullanici_id': kullaniciId,
      'birakis_tarihi': birakisTarihi.toIso8601String(),
      'gunluk_icilen_sigara': gunlukIcilenSigara,
      'paket_fiyati': paketFiyati,
      'paket_sigara_sayisi': paketSigaraSayisi,
    };
  }

  factory KullaniciVerileri.fromMap(Map<String, dynamic> map) {
    return KullaniciVerileri(
      id: map['id'],
      kullaniciId: map['kullanici_id'],
      birakisTarihi: DateTime.parse(map['birakis_tarihi']),
      gunlukIcilenSigara: map['gunluk_icilen_sigara'],
      paketFiyati: map['paket_fiyati'],
      paketSigaraSayisi: map['paket_sigara_sayisi'],
    );
  }
}