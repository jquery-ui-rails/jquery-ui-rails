/* English/Australia initialisation for the jQuery UI date picker plugin. */
/* Based on the en-GB initialisation. */
(function( factory ) {
	if ( typeof define === "function" && define.amd ) {

		// AMD. Register as an anonymous module.
		define([ "../datepicker" ], factory );
	} else {

		// Browser globals
		factory( jQuery.datepicker );
	}
}(function( datepicker ) {

datepicker.regional['fr-FR'] = {
  closeText: 'Fermer',
  prevText: 'précé',
  nextText: 'Suiv',
  currentText: 'aujourd\'hui',
  monthNames: ['janvier','février','mars','avril','mai','juin',
  'juillet','août','septembre','octobre','novembre','décembre'],
  monthNamesShort: ['jan.', 'fév', 'mar', 'avr', 'mai', 'juin',
  'juil', 'août', 'sept', 'oct', 'nov', 'dec'],
  dayNames: ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'],
  dayNamesShort: ['dim', 'lun', 'mar', 'mer', 'jeu', 'ven', 'sam'],
  dayNamesMin: ['di','lu','ma','me','je','ve','sa'],
  weekHeader: 'Semaine',
  dateFormat: 'dd/mm/yy',
  firstDay: 1,
  isRTL: false,
  showMonthAfterYear: false,
  yearSuffix: ''};
datepicker.setDefaults(datepicker.regional['fr-FR']);

return datepicker.regional['fr-FR'];

}));
