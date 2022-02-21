create or replace view voter_detail_export as 
select 
  voter_id as `ID`,
  name_last	as `Last Name`,
  name_suffix	as `Name Suffix`,
  name_first as `First Name`,
  name_middle	as `Middle Name`,
  concat_ws(', ', residence_address_line_1, residence_address_line_2) as `Primary Address Street`,
  residence_city as `Primary Address City`,
  residence_state	as `Primary Address State`,
  residence_zipcode	as `Primary Address Postal Code`,
  'USA'	as `Primary Address Country`,
  concat_ws(', ', mailing_address_line_1, mailing_address_line_3) as `Alternate Address Street`,
  mailing_city as `Alternate Address City`,
  mailing_state	as `Alternate Address State`,
  mailing_zipcode	as `Alternate Address Postal Code`,
  mailing_country	as `Alternate Address Country`,
  birth_date as `Birthdate`,
  email_address	as `Email Address`,
	
  concat(
      coalesce(
        concat('(', daytime_area_code, ') '),
        '' 
      ), 
      
      coalesce(
        daytime_phone_number,
        '' 
      ), 
    
      coalesce(
        concat(' ext ', daytime_phone_extension),
        '' 
      )
    ) as	`Other Phone`
    /*,
    county_code as `County Code`,
    requested_public_records_exemption as `Requested Public Records Exemption`,
    gender as `Gender`,
    race as `Race`,
    registration_date as `Registration Date`,
    party_affiliation as `Party Affiliation`,
    precinct as `Precinct`,
    precinct_group as `Precinct Group`,
    precinct_split as `Precinct Split`,
    precinct_suffix as `Precinct Suffix`,
    voter_status as `Voter Status`,
    congressional_district as `Congressional District`,
    house_district as `House District`,
    senate_district as `Senate District`,
    county_commission_district as `County Commission District`,
    school_board_district as `School Board District`
    */
 from voter_detail
 where requested_public_records_exemption = 'N'
;
