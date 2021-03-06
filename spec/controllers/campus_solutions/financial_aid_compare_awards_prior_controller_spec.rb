describe CampusSolutions::FinancialAidCompareAwardsPriorController do
  let(:user_id) { '12345' }

  context 'financial aid compare awards prior feed' do
    let(:feed) { :get }
    let(:options) { {aid_year: '2016', date: '2016-03-21-11.26.25', format: 'json'} }

    context 'unauthenticated user' do
      it 'returns 401' do
        get feed, params: options
        expect(response.status).to eq 401
      end
    end
    context 'authenticated user' do
      before { session['user_id'] = user_id }
      it 'has some field mapping info' do
        get feed, params: options
        json = JSON.parse response.body
        expect(json['feed']['status']['categories'][0]['title']).to eq 'Summary Information'
      end
      context 'no aid year provided' do
        let(:options) { {format: 'json'} }
        it 'returns empty' do
          get feed, params: options
          json = JSON.parse response.body
          expect(json).not_to include 'feed'
        end
      end
    end
  end
end
