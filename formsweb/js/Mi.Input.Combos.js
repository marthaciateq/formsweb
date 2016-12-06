Mi.Input.Combos.deleted = function (params) {
	var e = Mi.Input.combo(); 
	e.MiFill(Mi.Cookie.get('SESIONFORMSTABLAS').deleted, { value: 'deleted', text: 'deletedS' });
	return e;
}
