import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'landing-page',
      component: require('@/components/LandingPage').default
    },
    {
      path: '/patients/add',
      name: 'add-patient',
      component: require('@/components/NewPatient').default
    },
    {
      path: '/patients/liste',
      name: 'liste-patient',
      component: require('@/components/ListePatients').default
    },
    {
      path: '/patients/:infos',
      name: 'fiche-patient',
      props: { default: true },
      component: require('@/components/FichePatient').default
    },
    {
      path: '/docteurs/:infos',
      name: 'fiche-docteur',
      props: { default: true },
      component: require('@/components/FicheDocteur').default
    },
    {
      path: '/consultations/add/:infos',
      name: 'add-consultation',
      component: require('@/components/NewConsultation').default
    },
    {
      path: '/consultations/:id',
      name: 'fiche-consultation',
      props: { default: true },
      component: require('@/components/FicheConsultation').default
    },
    {
      path: '/actes/add/:id',
      name: 'add-acte',
      props: { default: true },
      component: require('@/components/NewActe').default
    },
    {
      path: '/rdv/add',
      name: 'add-rdv',
      component: require('@/components/NewRdv').default
    },
    {
      path: '/rdv/liste',
      name: 'liste-rdv',
      component: require('@/components/ListeRdv').default
    },
    {
      path: '*',
      redirect: '/'
    }
  ]
})
