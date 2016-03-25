function results = eeiComputations(eei, results)

    results.eei = eei;
    results.eei.eei = (results.eei.fc_marche - results.eei.fc_repos)/results.eei.v_marche;

end